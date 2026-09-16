import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../core/theme.dart';
import '../models/course.dart';
import '../providers/providers.dart';
import '../services/api_service.dart';
import '../widgets/ai_progress_overlay.dart';
import '../widgets/common.dart';
import '../widgets/glass_card.dart';

enum _Stage { idle, fileSelected, analyzing, complete }

class SyllabusScreen extends ConsumerStatefulWidget {
  const SyllabusScreen({super.key});

  @override
  ConsumerState<SyllabusScreen> createState() => _SyllabusScreenState();
}

class _SyllabusScreenState extends ConsumerState<SyllabusScreen> {
  _Stage _stage = _Stage.idle;
  String? _fileName;
  String? _fileSize;
  int _completedSteps = 0;
  Course? _result;

  static const _steps = [
    'Reading syllabus...',
    'Extracting course structure...',
    'Identifying COs...',
    'Mapping POs...',
    'Classifying Bloom levels...',
    'Building outcome graph...',
  ];

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.isNotEmpty) {
        final f = result.files.first;
        setState(() {
          _fileName = f.name;
          _fileSize = _formatBytes(f.size);
          _stage = _Stage.fileSelected;
        });
      }
    } catch (_) {
      // File picker can fail on some emulator/web setups — fall back to demo file.
      setState(() {
        _fileName = 'AIE-2102-syllabus.pdf';
        _fileSize = '482 KB';
        _stage = _Stage.fileSelected;
      });
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<void> _analyze() async {
    setState(() {
      _stage = _Stage.analyzing;
      _completedSteps = 0;
    });
    final api = ref.read(apiServiceProvider);
    await for (final event in api.analyzeSyllabus(
      fileName: _fileName ?? 'syllabus.pdf',
      courseCode: 'AIE-2102',
    )) {
      if (!mounted) return;
      if (event is AiProgressStep) {
        setState(() => _completedSteps++);
      } else if (event is Course) {
        setState(() {
          _result = event;
          _stage = _Stage.complete;
        });
        ref.read(activeCourseProvider.notifier).state = event;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Syllabus Intelligence')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          const Text('Turn your syllabus into an intelligent academic structure.',
              style: TextStyle(fontSize: 14, color: BloomColors.textSecondary, height: 1.4)),
          const SizedBox(height: 20),
          if (_stage == _Stage.idle || _stage == _Stage.fileSelected) _buildUploadCard(),
          if (_stage == _Stage.analyzing)
            AiProgressOverlay(
              title: 'Analyzing Syllabus',
              allSteps: _steps,
              completedCount: _completedSteps,
            ),
          if (_stage == _Stage.complete && _result != null) _buildResult(_result!),
        ],
      ),
    );
  }

  Widget _buildUploadCard() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          if (_stage == _Stage.idle) ...[
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: BloomColors.elevated,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(LucideIcons.fileUp, size: 26, color: BloomColors.violet),
            ),
            const SizedBox(height: 14),
            const Text('Upload Syllabus', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            const Text(
              'PDF only. BLOOM will extract units, topics, COs and POs automatically.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5, color: BloomColors.textSecondary),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(LucideIcons.filePlus, size: 17),
                label: const Text('Choose PDF'),
              ),
            ),
          ] else ...[
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: BloomColors.danger.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(LucideIcons.fileText, color: BloomColors.danger),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_fileName ?? '', overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                      Text(_fileSize ?? '', style: const TextStyle(fontSize: 12, color: BloomColors.textSecondary)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x, size: 18),
                  onPressed: () => setState(() {
                    _stage = _Stage.idle;
                    _fileName = null;
                  }),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _analyze,
                icon: const Icon(LucideIcons.sparkles, size: 17),
                label: const Text('Analyze with AI'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResult(Course course) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlassCard(
          borderColor: BloomColors.success.withOpacity(0.5),
          child: Row(
            children: [
              const Icon(LucideIcons.checkCircle2, color: BloomColors.success, size: 22),
              const SizedBox(width: 10),
              const Expanded(
                child: Text('ANALYSIS COMPLETE', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${course.code} — ${course.name}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  BloomBadge(label: '${course.unitCount} Units', color: BloomColors.blue),
                  BloomBadge(label: '${course.topicCount} Topics', color: BloomColors.cyan),
                  BloomBadge(label: '${course.coCount} COs', color: BloomColors.violet),
                  BloomBadge(label: '${course.poCount} POs', color: BloomColors.warning),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const SectionHeader(title: 'Example Topic Mappings'),
        const SizedBox(height: 10),
        for (final m in course.topicMappings.take(5))
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GlassCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(m.topic, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                  Expanded(
                    child: BloomBadge(label: m.bloomLevel, color: BloomLevelColors.of(m.bloomLevel), filled: true),
                  ),
                  const SizedBox(width: 6),
                  BloomBadge(label: m.co, color: BloomColors.blue),
                ],
              ),
            ),
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.push('/mapping'),
                child: const Text('View Mapping'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () => context.go('/questions'),
                child: const Text('Generate Questions'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
