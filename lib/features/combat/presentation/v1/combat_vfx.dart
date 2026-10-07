import 'package:flutter/material.dart';

class CombatPulseRing extends StatelessWidget {
  const CombatPulseRing({
    super.key,
    required this.color,
    required this.size,
    this.strokeWidth = 2,
  });

  final Color color;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final scale = 0.82 + (0.22 * value);
        final opacity = 0.72 - (0.42 * value);
        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: strokeWidth),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.28),
                    blurRadius: 18,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CombatImpactFlash extends StatelessWidget {
  const CombatImpactFlash({
    super.key,
    required this.triggerKey,
    required this.color,
  });

  final Object triggerKey;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: TweenAnimationBuilder<double>(
        key: ValueKey(triggerKey),
        tween: Tween(begin: 0.28, end: 0),
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
        builder: (context, opacity, child) =>
            ColoredBox(color: color.withValues(alpha: opacity)),
      ),
    );
  }
}
