import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../core/theme.dart';
import '../providers/providers.dart';
import '../widgets/common.dart';
import '../widgets/glass_card.dart';

class CoursesScreen extends ConsumerWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final course = ref.watch(activeCourseProvider); // primary course for this demo

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        const SectionHeader(title: 'My Courses', subtitle: 'Manage syllabi and outcome mapping'),
        const SizedBox(height: 16),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      gradient: BloomColors.brandGradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(LucideIcons.brainCircuit, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(course.code,
                            style: const TextStyle(fontSize: 13, color: BloomColors.textSecondary)),
                        Text(course.name,
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              AttainmentBar(label: 'Course Progress', value: course.progress * 100, color: BloomColors.success),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showCourseDetail(context, ref),
                      child: const Text('View Course'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/syllabus'),
                      icon: const Icon(LucideIcons.fileUp, size: 16),
                      label: const Text('Analyze Syllabus'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.go('/questions'),
                      icon: const Icon(LucideIcons.sparkles, size: 16),
                      label: const Text('Generate'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          borderColor: BloomColors.border,
          onTap: () => _showAddCourseSheet(context),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: BloomColors.elevated,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(LucideIcons.plus, color: BloomColors.violet),
              ),
              const SizedBox(width: 12),
              const Text('Add Course', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  void _showCourseDetail(BuildContext context, WidgetRef ref) {
    final course = ref.read(activeCourseProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: scrollController,
            children: [
              Text('${course.code} — ${course.name}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              const Text('Units', style: TextStyle(fontSize: 13, color: BloomColors.textSecondary)),
              const SizedBox(height: 8),
              for (final unit in course.units)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GlassCard(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(unit.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: unit.topics
                              .map((t) => BloomBadge(label: t, color: BloomColors.textSecondary))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddCourseSheet(BuildContext context) {
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
            const Text('Add Course', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            const TextField(decoration: InputDecoration(labelText: 'Course Code (e.g. CSE-3104)')),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Course Name')),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Course added to demo workspace.')),
                  );
                },
                child: const Text('Add Course'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
