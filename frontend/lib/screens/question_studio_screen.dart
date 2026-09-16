import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../core/theme.dart';
import '../models/question.dart';
import '../providers/providers.dart';
import '../services/api_service.dart';
import '../widgets/ai_progress_overlay.dart';
import '../widgets/common.dart';
import '../widgets/glass_card.dart';
import '../widgets/question_card.dart';

class QuestionStudioScreen extends ConsumerStatefulWidget {
  const QuestionStudioScreen({super.key});

  @override
  ConsumerState<QuestionStudioScreen> createState() => _QuestionStudioScreenState();
}

class _QuestionStudioScreenState extends ConsumerState<QuestionStudioScreen> {
  bool _generating = false;
  int _completedSteps = 0;
  bool _hasGenerated = false;
  final Set<String> _regeneratingIds = {};

  static const _steps = [
    'Balancing Bloom Taxonomy',
    'Mapping Course Outcomes',
    'Mapping Program Outcomes',
    'Generating Questions',
    'Quality Checking',
  ];

  Future<void> _generate() async {
    setState(() {
      _generating = true;
      _completedSteps = 0;
    });
    final api = ref.read(apiServiceProvider);
    final config = ref.read(assessmentConfigProvider);
    await for (final event in api.generateQuestions(config)) {
      if (!mounted) return;
      if (event is AiProgressStep) {
        setState(() => _completedSteps++);
      } else if (event is List<Question>) {
        ref.read(assessmentProvider.notifier).setAll(event);
        setState(() {
          _generating = false;
          _hasGenerated = true;
        });
      }
    }
  }

  Future<void> _regenerate(Question q) async {
    setState(() => _regeneratingIds.add(q.id));
    final api = ref.read(apiServiceProvider);
    final replacement = await api.regenerateQuestion(q);
    if (!mounted) return;
    ref.read(assessmentProvider.notifier).replaceQuestion(q.id, replacement);
    setState(() => _regeneratingIds.remove(q.id));
  }

  void _delete(Question q) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete question?'),
        content: const Text('This will remove the question from the current assessment.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              ref.read(assessmentProvider.notifier).removeQuestion(q.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: BloomColors.danger),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _edit(Question q) {
    final controller = TextEditingController(text: q.text);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Edit Question', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Question text'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(assessmentProvider.notifier).updateQuestion(q.copyWith(text: controller.text));
                  Navigator.pop(context);
                },
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questions = ref.watch(assessmentProvider);
    final config = ref.watch(assessmentConfigProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        const Text('Generate outcome-aligned assessments with AI.',
            style: TextStyle(fontSize: 14, color: BloomColors.textSecondary, height: 1.4)),
        const SizedBox(height: 18),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Configuration', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 14),
              _ConfigRow(label: 'Course', value: config.courseCode),
              _ConfigRow(
                label: 'Questions',
                value: '${config.questionCount}',
                onTap: () => _pickCount(context),
              ),
              _ConfigRow(label: 'Type', value: config.type),
              _ConfigRow(
                label: 'Difficulty',
                value: config.difficulty,
                onTap: () => _pickOption(
                  context,
                  title: 'Difficulty',
                  options: const ['Mixed', 'Easy', 'Medium', 'Hard'],
                  current: config.difficulty,
                  onSelected: (v) =>
                      ref.read(assessmentConfigProvider.notifier).state = config.copyWith(difficulty: v),
                ),
              ),
              _ConfigRow(
                label: 'Bloom',
                value: config.bloomFocus,
                onTap: () => _pickOption(
                  context,
                  title: 'Bloom Focus',
                  options: const ['Balanced', 'Lower-order', 'Higher-order'],
                  current: config.bloomFocus,
                  onSelected: (v) =>
                      ref.read(assessmentConfigProvider.notifier).state = config.copyWith(bloomFocus: v),
                ),
              ),
              _ConfigRow(label: 'CO', value: config.coMode),
              _ConfigRow(label: 'PO', value: config.poMode),
              _ConfigRow(label: 'Marks', value: '${config.marksPerQuestion} / question', isLast: true),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _generating ? null : _generate,
                  icon: const Icon(LucideIcons.sparkles, size: 18),
                  label: Text(_hasGenerated ? 'Regenerate Assessment' : 'Generate Assessment'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (_generating)
          AiProgressOverlay(title: 'Generating Assessment', allSteps: _steps, completedCount: _completedSteps),
        if (!_generating && _hasGenerated) ...[
          Row(
            children: [
              Expanded(
                child: SectionHeader(title: 'Generated Questions', subtitle: '${questions.length} questions'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < questions.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _regeneratingIds.contains(questions[i].id)
                  ? const GlassCard(child: BloomLoadingState(label: 'Regenerating question...'))
                  : QuestionCard(
                      question: questions[i],
                      index: i,
                      onEdit: () => _edit(questions[i]),
                      onRegenerate: () => _regenerate(questions[i]),
                      onDelete: () => _delete(questions[i]),
                    ),
            ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/assessment-preview'),
                  icon: const Icon(LucideIcons.eye, size: 17),
                  label: const Text('Preview Assessment'),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  void _pickCount(BuildContext context) {
    _pickOption(
      context,
      title: 'Question Count',
      options: const ['5', '10', '15', '20'],
      current: '${ref.read(assessmentConfigProvider).questionCount}',
      onSelected: (v) {
        final config = ref.read(assessmentConfigProvider);
        ref.read(assessmentConfigProvider.notifier).state =
            config.copyWith(questionCount: int.parse(v));
      },
    );
  }

  void _pickOption(
    BuildContext context, {
    required String title,
    required List<String> options,
    required String current,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              for (final o in options)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(o),
                  trailing: o == current ? const Icon(Icons.check, color: BloomColors.violet) : null,
                  onTap: () {
                    onSelected(o);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfigRow extends StatelessWidget {
  const _ConfigRow({required this.label, required this.value, this.onTap, this.isLast = false});
  final String label;
  final String value;
  final VoidCallback? onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: const TextStyle(fontSize: 13.5, color: BloomColors.textSecondary)),
                Row(
                  children: [
                    Text(value, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                    if (onTap != null) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right, size: 16, color: BloomColors.textSecondary),
                    ],
                  ],
                ),
              ],
            ),
            if (!isLast) const Padding(padding: EdgeInsets.only(top: 10), child: Divider(height: 1)),
          ],
        ),
      ),
    );
  }
}
