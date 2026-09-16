import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../core/theme.dart';
import '../providers/providers.dart';
import '../widgets/glass_card.dart';
import '../widgets/question_card.dart';

class AssessmentPreviewScreen extends ConsumerWidget {
  const AssessmentPreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(assessmentProvider);
    final course = ref.watch(activeCourseProvider);
    final totalMarks = questions.fold<int>(0, (sum, q) => sum + q.marks);

    return Scaffold(
      appBar: AppBar(title: const Text('Assessment Preview')),
      body: questions.isEmpty
          ? const _EmptyAssessment()
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text('CRESCENT INSTITUTE OF SCIENCE AND TECHNOLOGY',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 0.4)),
                      const SizedBox(height: 4),
                      const Text('Department of Artificial Intelligence & Data Science',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11.5, color: BloomColors.textSecondary)),
                      const SizedBox(height: 14),
                      const Divider(),
                      const SizedBox(height: 10),
                      Text('${course.code}', style: const TextStyle(fontSize: 12, color: BloomColors.textSecondary)),
                      Text(course.name.toUpperCase(),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 6),
                      const Text('MID-SEMESTER EXAMINATION',
                          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: BloomColors.violet)),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _MetaBlock(label: 'Duration', value: '1 Hour'),
                          Container(width: 1, height: 30, color: BloomColors.border),
                          _MetaBlock(label: 'Maximum Marks', value: '$totalMarks'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                for (int i = 0; i < questions.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: QuestionCard(
                      question: questions[i],
                      index: i,
                      showActions: false,
                      showAnswer: true,
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => context.pop(),
                        icon: const Icon(LucideIcons.pencil, size: 16),
                        label: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _export(context),
                        icon: const Icon(LucideIcons.download, size: 16),
                        label: const Text('Export'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _publish(context),
                    icon: const Icon(LucideIcons.send, size: 16),
                    label: const Text('Publish'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () => context.push('/student-preview'),
                    icon: const Icon(LucideIcons.userCheck, size: 16),
                    label: const Text('Preview as Student'),
                  ),
                ),
              ],
            ),
    );
  }

  void _export(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Assessment'),
        content: const Text(
          'In demo mode, export generates a print-ready paper locally. '
          'Connect the backend to enable PDF/DOCX export via the Python API.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Got it')),
        ],
      ),
    );
  }

  void _publish(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Assessment published to demo workspace.')),
    );
  }
}

class _MetaBlock extends StatelessWidget {
  const _MetaBlock({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
        Text(label, style: const TextStyle(fontSize: 11, color: BloomColors.textSecondary)),
      ],
    );
  }
}

class _EmptyAssessment extends StatelessWidget {
  const _EmptyAssessment();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.fileQuestion, size: 40, color: BloomColors.textSecondary),
            const SizedBox(height: 14),
            const Text('No assessment generated yet.', style: TextStyle(color: BloomColors.textSecondary)),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () => context.go('/questions'),
              child: const Text('Go to Question Studio'),
            ),
          ],
        ),
      ),
    );
  }
}
