import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// خلفية متدرجة فاخرة مع كرات ضوئية متوهجة تتنفس ببطء
/// (Ambient Glow Blobs) — في الوضع الداكن تظهر توهجات زمردية وذهبية
class GradientBackground extends StatefulWidget {
  final bool isDark;
  final Widget? child;

  const GradientBackground({super.key, required this.isDark, this.child});

  @override
  State<GradientBackground> createState() => _GradientBackgroundState();
}

class _GradientBackgroundState extends State<GradientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return Container(
          decoration: BoxDecoration(
            gradient: widget.isDark
                ? AppTheme.darkBackground
                : AppTheme.lightBackground,
          ),
          child: Stack(
            children: [
              // كرات ضوئية متوهجة (للداكن فقط — الفاتح توهجات خفيفة)
              Positioned(
                left: -60 + 30 * math.sin(t * 2 * math.pi),
                top: -40 + 25 * math.cos(t * 1.7 * math.pi),
                child: _GlowBlob(
                  size: 220,
                  color: widget.isDark
                      ? AppColors.glowEmerald
                      : AppColors.glowNavy,
                  opacity: widget.isDark ? 0.5 : 0.25,
                ),
              ),
              Positioned(
                right: -70 + 35 * math.cos(t * 2.3 * math.pi),
                top: 120 + 30 * math.sin(t * 1.4 * math.pi),
                child: _GlowBlob(
                  size: 180,
                  color: widget.isDark
                      ? AppColors.glowGold
                      : AppColors.glowGold,
                  opacity: widget.isDark ? 0.35 : 0.2,
                ),
              ),
              Positioned(
                left: 40 + 25 * math.sin(t * 1.9 * math.pi),
                bottom: -50 + 30 * math.cos(t * 1.6 * math.pi),
                child: _GlowBlob(
                  size: 200,
                  color: widget.isDark
                      ? AppColors.glowEmerald
                      : AppColors.glowNavy,
                  opacity: widget.isDark ? 0.4 : 0.2,
                ),
              ),
              if (widget.child != null) widget.child!,
            ],
          ),
        );
      },
    );
  }
}

/// كرة ضوئية متوهجة ناعمة
class _GlowBlob extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const _GlowBlob({
    required this.size,
    required this.color,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(opacity),
            color.withOpacity(opacity * 0.4),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}
