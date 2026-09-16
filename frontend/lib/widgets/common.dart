import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'glass_card.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.subtitle, this.trailing});

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle!, style: const TextStyle(fontSize: 13, color: BloomColors.textSecondary)),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// Small pill badge used for Bloom levels, CO/PO tags, difficulty, etc.
class BloomBadge extends StatelessWidget {
  const BloomBadge({
    super.key,
    required this.label,
    this.color = BloomColors.violet,
    this.icon,
    this.filled = false,
  });

  final String label;
  final Color color;
  final IconData? icon;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: filled ? color.withOpacity(0.18) : Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}

/// A compact stat tile for dashboard-style grids.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.color = BloomColors.violet,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 12, color: BloomColors.textSecondary)),
        ],
      ),
    );
  }
}

/// Animated number counter (e.g. "74%") used across dashboard/analytics.
class AnimatedCounter extends StatelessWidget {
  const AnimatedCounter({
    super.key,
    required this.value,
    this.suffix = '',
    this.style,
    this.duration = const Duration(milliseconds: 900),
  });

  final double value;
  final String suffix;
  final TextStyle? style;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, v, _) {
        final display = value % 1 == 0 ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
        return Text('$display$suffix', style: style);
      },
    );
  }
}

/// A slim horizontal progress/attainment bar with a label row.
class AttainmentBar extends StatelessWidget {
  const AttainmentBar({
    super.key,
    required this.label,
    required this.value, // 0-100
    this.target,
    this.color = BloomColors.violet,
  });

  final String label;
  final double value;
  final double? target;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final belowTarget = target != null && value < target!;
    final barColor = belowTarget ? BloomColors.warning : color;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            Text('${value.toStringAsFixed(0)}%',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: barColor)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: Stack(
            children: [
              Container(height: 8, color: BloomColors.elevated),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: (value / 100).clamp(0, 1)),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
                builder: (context, v, _) {
                  return FractionallySizedBox(
                    widthFactor: v,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [barColor.withOpacity(0.7), barColor]),
                      ),
                    ),
                  );
                },
              ),
              if (target != null)
                FractionallySizedBox(
                  widthFactor: (target! / 100).clamp(0, 1),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(width: 2, height: 8, color: Colors.white70),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Empty/error state used when a "backend" call fails in demo mode.
class BloomErrorState extends StatelessWidget {
  const BloomErrorState({
    super.key,
    this.message = 'Unable to connect to backend.\nDemo data is available.',
    required this.onUseDemoData,
  });

  final String message;
  final VoidCallback onUseDemoData;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 40, color: BloomColors.textSecondary),
            const SizedBox(height: 14),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: BloomColors.textSecondary)),
            const SizedBox(height: 18),
            ElevatedButton(onPressed: onUseDemoData, child: const Text('Use Demo Data')),
          ],
        ),
      ),
    );
  }
}

/// Full-width loading indicator with a status label — used during AI steps.
class BloomLoadingState extends StatelessWidget {
  const BloomLoadingState({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 3, color: BloomColors.violet),
          ),
          const SizedBox(height: 14),
          Text(label, style: const TextStyle(color: BloomColors.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }
}
