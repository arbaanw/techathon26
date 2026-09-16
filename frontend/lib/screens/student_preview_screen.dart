import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../core/theme.dart';
import '../models/question.dart';
import '../providers/providers.dart';
import '../widgets/common.dart';
import '../widgets/glass_card.dart';

class StudentPreviewScreen extends ConsumerStatefulWidget {
  const StudentPreviewScreen({super.key});

  @override
  ConsumerState<StudentPreviewScreen> createState() => _StudentPreviewScreenState();
}

class _StudentPreviewScreenState extends ConsumerState<StudentPreviewScreen> {
  int _index = 0;
  final Map<String, int> _answers = {};
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    final questions = ref.watch(assessmentProvider);

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Student Preview')),
        body: const Center(child: Text('No assessment available.', style: TextStyle(color: BloomColors.textSecondary))),
      );
    }

    if (_submitted) {
      return Scaffold(
        appBar: AppBar(title: const Text('Results')),
        body: _buildResults(questions),
      );
    }

    final q = questions[_index];
    return Scaffold(
      appBar: AppBar(title: const Text('Student Preview')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Question ${_index + 1} / ${questions.length}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: BloomColors.textSecondary)),
                  Text('${q.marks} marks', style: const TextStyle(fontSize: 12, color: BloomColors.textSecondary)),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: (_index + 1) / questions.length,
                  minHeight: 6,
                  backgroundColor: BloomColors.elevated,
                  valueColor: const AlwaysStoppedAnimation(BloomColors.violet),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(q.text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, height: 1.4)),
                        const SizedBox(height: 18),
                        for (int i = 0; i < q.options.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _OptionTile(
                              letter: String.fromCharCode(65 + i),
                              text: q.options[i],
                              selected: _answers[q.id] == i,
                              onTap: () => setState(() => _answers[q.id] = i),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  if (_index > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _index--),
                        child: const Text('Previous'),
                      ),
                    ),
                  if (_index > 0) const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_index < questions.length - 1) {
                          setState(() => _index++);
                        } else {
                          setState(() => _submitted = true);
                        }
                      },
                      child: Text(_index < questions.length - 1 ? 'Next' : 'Submit Assessment'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResults(List<Question> questions) {
    int correct = 0;
    int scoredMarks = 0;
    final totalMarks = questions.fold<int>(0, (s, q) => s + q.marks);
    final coScores = <String, List<int>>{}; // co -> [correct, total]

    for (final q in questions) {
      final isCorrect = _answers[q.id] == q.correctIndex;
      if (isCorrect) {
        correct++;
        scoredMarks += q.marks;
      }
      coScores.putIfAbsent(q.co, () => [0, 0]);
      coScores[q.co]![1]++;
      if (isCorrect) coScores[q.co]![0]++;
    }

    final percent = totalMarks == 0 ? 0.0 : (scoredMarks / totalMarks) * 100;
    final passed = percent >= 40;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        GlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                passed ? LucideIcons.checkCircle2 : LucideIcons.xCircle,
                size: 40,
                color: passed ? BloomColors.success : BloomColors.danger,
              ),
              const SizedBox(height: 12),
              AnimatedCounter(
                value: scoredMarks.toDouble(),
                suffix: ' / $totalMarks',
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              AnimatedCounter(
                value: percent,
                suffix: '%',
                style: const TextStyle(fontSize: 15, color: BloomColors.textSecondary, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              BloomBadge(
                label: passed ? 'Passed' : 'Needs Improvement',
                color: passed ? BloomColors.success : BloomColors.danger,
                filled: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const SectionHeader(title: 'CO Performance'),
        const SizedBox(height: 12),
        for (final entry in coScores.entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AttainmentBar(
              label: entry.key,
              value: entry.value[1] == 0 ? 0 : (entry.value[0] / entry.value[1]) * 100,
              color: BloomColors.cyan,
            ),
          ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => setState(() {
              _submitted = false;
              _index = 0;
              _answers.clear();
            }),
            child: const Text('Retake Preview'),
          ),
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.letter, required this.text, required this.selected, required this.onTap});
  final String letter;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: selected ? BloomColors.violet.withOpacity(0.14) : BloomColors.elevated,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: selected ? BloomColors.violet : BloomColors.border, width: selected ? 1.5 : 1),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 13,
                backgroundColor: selected ? BloomColors.violet : BloomColors.surface,
                child: Text(letter,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: selected ? Colors.white : BloomColors.textSecondary)),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(text, style: const TextStyle(fontSize: 14, height: 1.3))),
            ],
          ),
        ),
      ),
    );
  }
}
