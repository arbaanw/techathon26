import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../core/theme.dart';
import '../models/question.dart';
import 'common.dart';
import 'glass_card.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.question,
    required this.index,
    this.onEdit,
    this.onRegenerate,
    this.onDelete,
    this.showActions = true,
    this.showAnswer = true,
  });

  final Question question;
  final int index;
  final VoidCallback? onEdit;
  final VoidCallback? onRegenerate;
  final VoidCallback? onDelete;
  final bool showActions;
  final bool showAnswer;

  @override
  Widget build(BuildContext context) {
    final bloomColor = BloomLevelColors.of(question.bloomLevel);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: BloomColors.elevated,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('${index + 1}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  question.text,
                  style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, height: 1.35),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(question.options.length, (i) {
            final letter = String.fromCharCode(65 + i);
            final isCorrect = showAnswer && i == question.correctIndex;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isCorrect ? BloomColors.success.withOpacity(0.12) : BloomColors.elevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCorrect ? BloomColors.success.withOpacity(0.6) : BloomColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 11,
                      backgroundColor: isCorrect ? BloomColors.success : BloomColors.surface,
                      child: Text(letter,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isCorrect ? Colors.white : BloomColors.textSecondary)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(question.options[i],
                            style: const TextStyle(fontSize: 13.5, height: 1.3))),
                    if (isCorrect)
                      const Icon(Icons.check_circle_rounded, color: BloomColors.success, size: 18),
                  ],
                ),
              ),
            );
          }),
          if (showAnswer) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: BloomColors.cyan.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(LucideIcons.lightbulb, size: 15, color: BloomColors.cyan),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(question.explanation,
                        style: const TextStyle(fontSize: 12.5, color: BloomColors.textSecondary, height: 1.4)),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              BloomBadge(label: question.bloomLevel, color: bloomColor, filled: true),
              BloomBadge(label: question.co, color: BloomColors.blue),
              BloomBadge(label: question.po, color: BloomColors.violet),
              BloomBadge(label: question.difficulty, color: _difficultyColor(question.difficulty)),
              BloomBadge(label: '${question.marks} marks', color: BloomColors.textSecondary),
            ],
          ),
          if (showActions) ...[
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(LucideIcons.pencil, size: 16),
                    label: const Text('Edit'),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: onRegenerate,
                    icon: const Icon(LucideIcons.refreshCw, size: 16),
                    label: const Text('Regenerate'),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: onDelete,
                    style: TextButton.styleFrom(foregroundColor: BloomColors.danger),
                    icon: const Icon(LucideIcons.trash2, size: 16),
                    label: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _difficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return BloomColors.success;
      case 'Hard':
        return BloomColors.danger;
      default:
        return BloomColors.warning;
    }
  }
}
