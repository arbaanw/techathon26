import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Shows a vertical checklist of AI processing steps, animating a spinner on
/// the active step and a check mark on completed ones. Used by Syllabus
/// Intelligence and Question Studio to visualize the mock AI pipeline.
class AiProgressOverlay extends StatelessWidget {
  const AiProgressOverlay({
    super.key,
    required this.allSteps,
    required this.completedCount,
    this.title = 'AI is working...',
  });

  final List<String> allSteps;
  final int completedCount; // steps fully completed (0..allSteps.length)
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: BloomColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BloomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShaderMask(
                shaderCallback: (r) => BloomColors.brandGradient.createShader(r),
                child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 18),
          for (int i = 0; i < allSteps.length; i++) _StepRow(
                label: allSteps[i],
                state: i < completedCount
                    ? _StepState.done
                    : i == completedCount
                        ? _StepState.active
                        : _StepState.pending,
                isLast: i == allSteps.length - 1,
              ),
        ],
      ),
    );
  }
}

enum _StepState { pending, active, done }

class _StepRow extends StatelessWidget {
  const _StepRow({required this.label, required this.state, required this.isLast});
  final String label;
  final _StepState state;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    Color color;
    Widget icon;
    switch (state) {
      case _StepState.done:
        color = BloomColors.success;
        icon = Icon(Icons.check_circle_rounded, color: color, size: 20);
        break;
      case _StepState.active:
        color = BloomColors.violet;
        icon = SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2.4, color: color),
        );
        break;
      case _StepState.pending:
        color = BloomColors.textSecondary.withOpacity(0.4);
        icon = Icon(Icons.circle_outlined, color: color, size: 18);
    }

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Row(
        children: [
          SizedBox(width: 22, child: Center(child: icon)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: state == _StepState.active ? FontWeight.w700 : FontWeight.w500,
                color: state == _StepState.pending ? BloomColors.textSecondary : BloomColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
