import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme.dart';
import '../data/mock_data.dart';
import '../providers/providers.dart';
import '../widgets/common.dart';
import '../widgets/glass_card.dart';

class MappingScreen extends ConsumerWidget {
  const MappingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final course = ref.watch(activeCourseProvider);
    final pos = course.programOutcomes.map((p) => p.code).toList();
    final cos = course.outcomes.map((c) => c.code).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('CO / PO Mapping')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          const SectionHeader(title: 'Topic → CO → PO', subtitle: 'AI-generated outcome mapping'),
          const SizedBox(height: 12),
          for (final m in course.topicMappings)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GlassCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m.topic, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        BloomBadge(label: 'Bloom: ${m.bloomLevel}', color: BloomLevelColors.of(m.bloomLevel), filled: true),
                        BloomBadge(label: 'CO: ${m.co}', color: BloomColors.blue),
                        BloomBadge(label: 'PO: ${m.po}', color: BloomColors.violet),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),
          const SectionHeader(title: 'CO → PO Matrix', subtitle: 'Strength of contribution'),
          const SizedBox(height: 12),
          GlassCard(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                defaultColumnWidth: const FixedColumnWidth(74),
                border: TableBorder.symmetric(inside: const BorderSide(color: BloomColors.border)),
                children: [
                  TableRow(
                    children: [
                      const SizedBox(width: 54),
                      for (final po in pos)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                              child: Text(po, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                        ),
                    ],
                  ),
                  for (final co in cos)
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(co, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                        ),
                        for (final po in pos)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Center(child: _StrengthChip(level: MockData.coPoMatrix[co]?[po] ?? 0)),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Wrap(
            spacing: 14,
            runSpacing: 8,
            children: [
              _LegendDot(label: 'Strong', color: BloomColors.success),
              _LegendDot(label: 'Moderate', color: BloomColors.warning),
              _LegendDot(label: 'Low', color: BloomColors.textSecondary),
            ],
          ),
        ],
      ),
    );
  }
}

class _StrengthChip extends StatelessWidget {
  const _StrengthChip({required this.level});
  final int level; // 0 none, 1 low, 2 moderate, 3 strong

  @override
  Widget build(BuildContext context) {
    if (level == 0) {
      return const Text('—', style: TextStyle(color: BloomColors.textSecondary));
    }
    final label = level == 3 ? 'S' : (level == 2 ? 'M' : 'L');
    final color = level == 3
        ? BloomColors.success
        : level == 2
            ? BloomColors.warning
            : BloomColors.textSecondary;
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color.withOpacity(0.18), shape: BoxShape.circle),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: color)),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: BloomColors.textSecondary)),
      ],
    );
  }
}
