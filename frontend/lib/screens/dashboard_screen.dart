import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../core/theme.dart';
import '../data/mock_data.dart';
import '../models/question.dart';
import '../providers/providers.dart';
import '../widgets/common.dart';
import '../widgets/glass_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final course = ref.watch(activeCourseProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        const Text('Good morning, Faculty',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        const Text('Build smarter assessments.',
            style: TextStyle(fontSize: 14, color: BloomColors.textSecondary)),
        const SizedBox(height: 18),

        // Hero card
        GradientHeroCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(LucideIcons.sparkles, color: Colors.white, size: 22),
              const SizedBox(height: 12),
              const Text(
                'Turn your syllabus into measurable learning outcomes.',
                style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700, height: 1.3),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: BloomColors.primaryPurple,
                    ),
                    onPressed: () => context.go('/questions'),
                    icon: const Icon(LucideIcons.sparkles, size: 17),
                    label: const Text('Generate Assessment'),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white70),
                    ),
                    onPressed: () => context.push('/syllabus'),
                    icon: const Icon(LucideIcons.fileUp, size: 17),
                    label: const Text('Analyze Syllabus'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Stats grid
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: const [
            StatTile(label: 'Courses', value: '03', icon: LucideIcons.bookOpen, color: BloomColors.blue),
            StatTile(label: 'Assessments', value: '12', icon: LucideIcons.clipboardList, color: BloomColors.cyan),
            StatTile(label: 'Questions', value: '148', icon: LucideIcons.helpCircle, color: BloomColors.violet),
            StatTile(label: 'CO Attainment', value: '74%', icon: LucideIcons.target, color: BloomColors.success),
          ],
        ),
        const SizedBox(height: 20),

        // Pipeline
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: 'BLOOM Pipeline', subtitle: 'From syllabus to insight'),
              const SizedBox(height: 16),
              const _Pipeline(steps: [
                ('Syllabus', LucideIcons.fileText),
                ('AI Analysis', LucideIcons.brainCircuit),
                ('CO/PO Mapping', LucideIcons.gitBranch),
                ('Question Generation', LucideIcons.sparkles),
                ('Assessment', LucideIcons.clipboardCheck),
                ('Analytics', LucideIcons.barChart3),
              ]),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // CO Attainment chart
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: 'CO Attainment', subtitle: 'Target: 70%'),
              const SizedBox(height: 16),
              for (final co in course.outcomes)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AttainmentBar(label: co.code, value: co.attainment, target: 70, color: BloomColors.cyan),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Bloom distribution
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: 'Bloom Distribution', subtitle: 'Across question bank'),
              const SizedBox(height: 16),
              for (final level in kBloomLevels)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AttainmentBar(
                    label: level,
                    value: MockData.bloomDistribution[level] ?? 0,
                    color: BloomLevelColors.of(level),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // AI Insight card
        GlassCard(
          borderColor: BloomColors.warning.withOpacity(0.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: BloomColors.warning.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(LucideIcons.alertTriangle, color: BloomColors.warning, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text('CO3 needs attention.',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _MiniStat(label: 'Current', value: '58%', color: BloomColors.danger),
                  ),
                  Expanded(
                    child: _MiniStat(label: 'Target', value: '70%', color: BloomColors.success),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'Increase Analyze-level practice for Knowledge Representation.',
                style: TextStyle(fontSize: 13, color: BloomColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.push('/ai-insights'),
                  child: const Text('View AI Insights'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
        Text(label, style: const TextStyle(fontSize: 12, color: BloomColors.textSecondary)),
      ],
    );
  }
}

class _Pipeline extends StatelessWidget {
  const _Pipeline({required this.steps});
  final List<(String, IconData)> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < steps.length; i++)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      gradient: BloomColors.brandGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(steps[i].$2, size: 17, color: Colors.white),
                  ),
                  if (i != steps.length - 1)
                    Container(width: 2, height: 26, color: BloomColors.border),
                ],
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(steps[i].$1, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
      ],
    );
  }
}
