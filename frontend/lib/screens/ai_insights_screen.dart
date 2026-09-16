import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../core/theme.dart';
import '../models/analytics.dart';
import '../providers/providers.dart';
import '../widgets/common.dart';
import '../widgets/glass_card.dart';

class AiInsightsScreen extends ConsumerWidget {
  const AiInsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(insightsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('AI Insights')),
      body: insightsAsync.when(
        loading: () => const Center(child: BloomLoadingState(label: 'Analyzing outcomes...')),
        error: (e, st) => BloomErrorState(onUseDemoData: () => ref.invalidate(insightsProvider)),
        data: (insights) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            const Text('AI-generated recommendations based on current attainment data.',
                style: TextStyle(fontSize: 13.5, color: BloomColors.textSecondary, height: 1.4)),
            const SizedBox(height: 18),
            for (final insight in insights)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _InsightCard(insight: insight),
              ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showImprovementPlan(context, ref),
                icon: const Icon(LucideIcons.listChecks, size: 17),
                label: const Text('Generate Improvement Plan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImprovementPlan(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        maxChildSize: 0.92,
        builder: (context, scrollController) {
          final planAsync = ref.watch(improvementPlanProvider);
          return Padding(
            padding: const EdgeInsets.all(20),
            child: planAsync.when(
              loading: () => const Center(child: BloomLoadingState(label: 'Building improvement plan...')),
              error: (e, st) => const Center(child: Text('Unable to load plan.')),
              data: (plan) => ListView(
                controller: scrollController,
                children: [
                  const Text('Improvement Plan', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  for (final item in plan)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GlassCard(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                BloomBadge(
                                  label: item.priority,
                                  color: item.priority == 'High'
                                      ? BloomColors.danger
                                      : item.priority == 'Medium'
                                          ? BloomColors.warning
                                          : BloomColors.textSecondary,
                                  filled: true,
                                ),
                                const SizedBox(width: 8),
                                const Text('Priority', style: TextStyle(fontSize: 11, color: BloomColors.textSecondary)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text('Issue', style: TextStyle(fontSize: 11, color: BloomColors.textSecondary)),
                            Text(item.issue, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            const Text('Recommended Action', style: TextStyle(fontSize: 11, color: BloomColors.textSecondary)),
                            Text(item.action, style: const TextStyle(fontSize: 13, height: 1.35)),
                            const SizedBox(height: 8),
                            const Text('Expected Impact', style: TextStyle(fontSize: 11, color: BloomColors.textSecondary)),
                            Text(item.impact,
                                style: const TextStyle(fontSize: 13, height: 1.35, color: BloomColors.success)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.insight});
  final AiInsight insight;

  Color get _color {
    switch (insight.severity) {
      case 'critical':
        return BloomColors.danger;
      case 'warning':
        return BloomColors.warning;
      default:
        return BloomColors.cyan;
    }
  }

  IconData get _icon {
    switch (insight.severity) {
      case 'critical':
        return LucideIcons.alertOctagon;
      case 'warning':
        return LucideIcons.alertTriangle;
      default:
        return LucideIcons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderColor: _color.withOpacity(0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: _color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                child: Icon(_icon, color: _color, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(insight.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(insight.metricLabel, style: const TextStyle(fontSize: 12.5, color: BloomColors.textSecondary)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MiniMetric(label: 'Current', value: insight.current, color: _color),
              ),
              Expanded(
                child: _MiniMetric(label: 'Target', value: insight.target, color: BloomColors.success),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: BloomColors.elevated, borderRadius: BorderRadius.circular(12)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(LucideIcons.sparkles, size: 15, color: BloomColors.violet),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(insight.recommendation,
                      style: const TextStyle(fontSize: 12.5, height: 1.4, color: BloomColors.textSecondary)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.label, required this.value, required this.color});
  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCounter(
          value: value,
          suffix: '%',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color),
        ),
        Text(label, style: const TextStyle(fontSize: 11.5, color: BloomColors.textSecondary)),
      ],
    );
  }
}
