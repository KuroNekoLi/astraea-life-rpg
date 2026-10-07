import 'package:flutter/material.dart';

class CombatPulseRing extends StatefulWidget {
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
  State<CombatPulseRing> createState() => _CombatPulseRingState();
}

class _CombatPulseRingState extends State<CombatPulseRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  late final Animation<double> _scale = Tween<double>(
    begin: 0.86,
    end: 1.08,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  late final Animation<double> _opacity = Tween<double>(
    begin: 0.25,
    end: 0.72,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.scale(
            scale: _scale.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.color,
                  width: widget.strokeWidth,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.28),
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
        builder: (context, opacity, child) => ColoredBox(
          color: color.withValues(alpha: opacity),
        ),
      ),
    );
  }
}
