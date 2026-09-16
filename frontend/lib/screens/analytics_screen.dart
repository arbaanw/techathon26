import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme.dart';
import '../models/analytics.dart';
import '../providers/providers.dart';
import '../widgets/common.dart';
import '../widgets/glass_card.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(analyticsProvider);

    return analyticsAsync.when(
      loading: () => const Center(child: BloomLoadingState(label: 'Loading analytics...')),
      error: (e, st) => BloomErrorState(onUseDemoData: () => ref.invalidate(analyticsProvider)),
      data: (data) => _AnalyticsBody(data: data),
    );
  }
}

class _AnalyticsBody extends StatelessWidget {
  const _AnalyticsBody({required this.data});
  final AnalyticsSummary data;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        const Text('Understand what students learned — not just what they scored.',
            style: TextStyle(fontSize: 14, color: BloomColors.textSecondary, height: 1.4)),
        const SizedBox(height: 18),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            StatTile(label: 'Students', value: '${data.totalStudents}', icon: Icons.groups_rounded, color: BloomColors.blue),
            StatTile(
                label: 'Average Score',
                value: '${data.averageScore.toStringAsFixed(1)} / ${data.maxScore.toStringAsFixed(0)}',
                icon: Icons.grade_rounded,
                color: BloomColors.cyan),
            StatTile(label: 'Pass Rate', value: '${data.passRate.toStringAsFixed(0)}%', icon: Icons.verified_rounded, color: BloomColors.success),
            StatTile(label: 'CO Attainment', value: '${data.coAttainment.toStringAsFixed(0)}%', icon: Icons.track_changes_rounded, color: BloomColors.violet),
          ],
        ),
        const SizedBox(height: 20),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: 'CO Attainment', subtitle: 'Target: ${data.coTarget.toStringAsFixed(0)}%'),
              const SizedBox(height: 18),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    maxY: 100,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 25,
                      getDrawingHorizontalLine: (v) => const FlLine(color: BloomColors.border, strokeWidth: 1),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final i = value.toInt();
                            if (i < 0 || i >= data.coBreakdown.length) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(data.coBreakdown[i].code,
                                  style: const TextStyle(fontSize: 10.5, color: BloomColors.textSecondary)),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: [
                      for (int i = 0; i < data.coBreakdown.length; i++)
                        BarChartGroupData(x: i, barRods: [
                          BarChartRodData(
                            toY: data.coBreakdown[i].value,
                            color: data.coBreakdown[i].value < data.coTarget
                                ? BloomColors.warning
                                : BloomColors.cyan,
                            width: 20,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: 'PO Attainment'),
              const SizedBox(height: 16),
              for (final po in data.poBreakdown)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AttainmentBar(label: po.code, value: po.value, target: 70, color: BloomColors.blue),
                ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: 'Bloom Performance', subtitle: 'Weak areas highlighted'),
              const SizedBox(height: 16),
              for (final entry in data.bloomPerformance.entries)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AttainmentBar(
                    label: entry.key,
                    value: entry.value,
                    target: 65,
                    color: BloomLevelColors.of(entry.key),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
