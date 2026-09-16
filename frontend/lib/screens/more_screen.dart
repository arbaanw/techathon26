import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../core/theme.dart';
import '../widgets/glass_card.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  static const _items = [
    ('Syllabus Intelligence', 'Upload and analyze syllabi with AI', LucideIcons.fileUp, '/syllabus', BloomColors.violet),
    ('CO / PO Mapping', 'Explore outcome relationships', LucideIcons.gitBranch, '/mapping', BloomColors.blue),
    ('Assessment Preview', 'Review the generated exam paper', LucideIcons.clipboardList, '/assessment-preview', BloomColors.cyan),
    ('Student Preview', 'Experience the assessment as a student', LucideIcons.userCheck, '/student-preview', BloomColors.success),
    ('AI Insights', 'Recommendations to close outcome gaps', LucideIcons.sparkles, '/ai-insights', BloomColors.warning),
    ('Settings', 'Appearance, AI engine & backend config', LucideIcons.settings, '/settings', BloomColors.textSecondary),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          for (final item in _items)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GlassCard(
                onTap: () => context.push(item.$4),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: item.$5.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(item.$3, color: item.$5, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.$1, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text(item.$2, style: const TextStyle(fontSize: 12, color: BloomColors.textSecondary)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: BloomColors.textSecondary, size: 18),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
