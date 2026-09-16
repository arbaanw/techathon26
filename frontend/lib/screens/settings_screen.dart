import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../core/theme.dart';
import '../providers/providers.dart';
import '../widgets/common.dart';
import '../widgets/glass_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          GlassCard(
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(gradient: BloomColors.brandGradient, borderRadius: BorderRadius.circular(16)),
                  child: const Icon(LucideIcons.user, color: Colors.white),
                ),
                const SizedBox(width: 14),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Faculty Demo', style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700)),
                    SizedBox(height: 2),
                    Text('Crescent Institute of Science and Technology',
                        style: TextStyle(fontSize: 12, color: BloomColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Appearance'),
          const SizedBox(height: 10),
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Column(
              children: [
                _RadioRow(
                  label: 'Dark',
                  icon: LucideIcons.moon,
                  selected: themeMode == ThemeMode.dark,
                  onTap: () => ref.read(themeModeProvider.notifier).state = ThemeMode.dark,
                ),
                _RadioRow(
                  label: 'Light',
                  icon: LucideIcons.sun,
                  selected: themeMode == ThemeMode.light,
                  onTap: () => ref.read(themeModeProvider.notifier).state = ThemeMode.light,
                ),
                _RadioRow(
                  label: 'System',
                  icon: LucideIcons.monitor,
                  selected: themeMode == ThemeMode.system,
                  onTap: () => ref.read(themeModeProvider.notifier).state = ThemeMode.system,
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SectionHeader(title: 'AI Engine'),
          const SizedBox(height: 10),
          GlassCard(
            child: Column(
              children: [
                _InfoRow(icon: LucideIcons.brainCircuit, label: 'Engine', value: 'Gemini'),
                _InfoRow(icon: LucideIcons.wifiOff, label: 'Connection', value: 'Demo Mode'),
                _InfoRow(icon: LucideIcons.server, label: 'Backend', value: 'Python API', isLast: true),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Backend'),
          const SizedBox(height: 10),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Backend URL', style: TextStyle(fontSize: 12, color: BloomColors.textSecondary)),
                const SizedBox(height: 4),
                const Text('http://localhost:8000', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: BloomColors.elevated,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(LucideIcons.shieldCheck, size: 16, color: BloomColors.success),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'No API keys are stored or required. BLOOM runs fully offline in demo mode.',
                          style: TextStyle(fontSize: 12, color: BloomColors.textSecondary, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text('BLOOM v1.0.0 · Hackathon Build', style: TextStyle(fontSize: 11.5, color: BloomColors.textSecondary.withOpacity(0.7))),
          ),
        ],
      ),
    );
  }
}

class _RadioRow extends StatelessWidget {
  const _RadioRow({required this.label, required this.icon, required this.selected, required this.onTap, this.isLast = false});
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 18, color: selected ? BloomColors.violet : BloomColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 18,
              color: selected ? BloomColors.violet : BloomColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value, this.isLast = false});
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 17, color: BloomColors.textSecondary),
              const SizedBox(width: 10),
              Expanded(child: Text(label, style: const TextStyle(fontSize: 13.5))),
              Text(value, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
            ],
          ),
          if (!isLast) const Padding(padding: EdgeInsets.only(top: 10), child: Divider(height: 1)),
        ],
      ),
    );
  }
}
