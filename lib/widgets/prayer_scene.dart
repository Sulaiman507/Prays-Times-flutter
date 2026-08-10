import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/prayer_type.dart';

/// مشهد سماوي ديناميكي يتغير حسب وقت الصلاة الحالي:
/// فجر → شبه شروق | ظهر → مشمس | مغرب → غروب | عشاء → نجوم وشهب
class PrayerScene extends StatefulWidget {
  final PrayerType prayer;
  final bool isDark;

  const PrayerScene({super.key, required this.prayer, required this.isDark});

  @override
  State<PrayerScene> createState() => _PrayerSceneState();
}

class _PrayerSceneState extends State<PrayerScene>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // دورة بطيئة (14 ثانية) — تظهر الشهب وتختفي بهدوء
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
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
      builder: (context, _) => CustomPaint(
        size: Size.infinite,
        painter: _SkyPainter(
          prayer: widget.prayer,
          t: _controller.value,
          isDark: widget.isDark,
        ),
      ),
    );
  }
}

/// رسّام السماء — يرسم تدرجات وشمس ونجوم وشهب حسب الصلاة
class _SkyPainter extends CustomPainter {
  final PrayerType prayer;
  final double t; // 0..1 دورة الأنيميشن
  final bool isDark;

  _SkyPainter({required this.prayer, required this.t, required this.isDark});

  // نجوم ثابتة (مواقع عشوائية مسبقة بثابت لتجنب الوميض العشوائي)
  static final List<_Star> _stars = _generateStars();

  static List<_Star> _generateStars() {
    final rnd = math.Random(42);
    return List.generate(45, (_) {
      return _Star(
        x: rnd.nextDouble(),
        y: rnd.nextDouble() * 0.75,
        size: 0.8 + rnd.nextDouble() * 1.8,
        phase: rnd.nextDouble() * 2 * math.pi,
        speed: 0.6 + rnd.nextDouble() * 1.2,
      );
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    switch (prayer) {
      case PrayerType.fajr:
        _paintFajr(canvas, w, h);
        break;
      case PrayerType.sunrise:
        _paintSunrise(canvas, w, h);
        break;
      case PrayerType.dhuhr:
        _paintDhuhr(canvas, w, h);
        break;
      case PrayerType.asr:
        _paintAsr(canvas, w, h);
        break;
      case PrayerType.maghrib:
        _paintMaghrib(canvas, w, h);
        break;
      case PrayerType.isha:
        _paintIsha(canvas, w, h);
        break;
    }
  }

  // ---------- الفجر: سماء داكنة تتحول لتوهج شروق ناعم ----------
  void _paintFajr(Canvas canvas, double w, double h) {
    final rect = Rect.fromLTWH(0, 0, w, h);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1A2547), // كحلي ليلي
            Color(0xFF3A3A6E), // بنفسجي فاتح
            Color(0xFFB5654E), // برتقالي هادئ
            Color(0xFFE8A87C), // ذهبي وردي عند الأفق
          ],
          stops: [0, 0.45, 0.8, 1],
        ).createShader(rect),
    );

    // شمس خافتة توشك على الشروق
    final sunY = h * 0.82;
    final sun = Offset(w * 0.5, sunY);
    canvas.drawCircle(
      sun,
      w * 0.09,
      Paint()..color = const Color(0xFFF5C99A).withOpacity(0.9),
    );
    // هالة
    canvas.drawCircle(
      sun,
      w * 0.16,
      Paint()
        ..color = const Color(0xFFF5C99A).withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
    );

    // نجوم خافتة تتلاشى تدريجياً
    _paintStars(canvas, w, h, opacity: 0.25);
  }

  // ---------- الشروق: سماء صباحية ذهبية ----------
  void _paintSunrise(Canvas canvas, double w, double h) {
    final rect = Rect.fromLTWH(0, 0, w, h);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF5B7FA6),
            Color(0xFF9DB8D9),
            Color(0xFFF2C98A),
            Color(0xFFF7A86C),
          ],
          stops: [0, 0.5, 0.82, 1],
        ).createShader(rect),
    );

    // شمس مرتفعة قليلاً
    final sun = Offset(w * 0.5, h * 0.68);
    canvas.drawCircle(sun, w * 0.085, Paint()..color = const Color(0xFFFFDF9E));
    canvas.drawCircle(
      sun,
      w * 0.16,
      Paint()
        ..color = const Color(0xFFFFDF9E).withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
    );
  }

  // ---------- الظهر: سماء زرقاء صافية وشمس ساطعة ----------
  void _paintDhuhr(Canvas canvas, double w, double h) {
    final rect = Rect.fromLTWH(0, 0, w, h);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2E6FB7), Color(0xFF4F93D4), Color(0xFF7FB3E8)],
        ).createShader(rect),
    );

    // شمس ساطعة بأشعة
    final sun = Offset(w * 0.78, h * 0.22);
    canvas.drawCircle(sun, w * 0.10, Paint()..color = const Color(0xFFFFF3C4));
    canvas.drawCircle(
      sun,
      w * 0.22,
      Paint()
        ..color = const Color(0xFFFFF3C4).withOpacity(0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40),
    );
  }

  // ---------- العصر: أزرق هادئ وشمس مائلة ----------
  void _paintAsr(Canvas canvas, double w, double h) {
    final rect = Rect.fromLTWH(0, 0, w, h);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3D7CB3), Color(0xFF6FA6D4), Color(0xFFA8C8E4)],
        ).createShader(rect),
    );

    final sun = Offset(w * 0.68, h * 0.4);
    canvas.drawCircle(sun, w * 0.085, Paint()..color = const Color(0xFFFBE9B7));
    canvas.drawCircle(
      sun,
      w * 0.17,
      Paint()
        ..color = const Color(0xFFFBE9B7).withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 35),
    );
  }

  // ---------- المغرب: غروب برتقالي/أحمر مع شمس تغرب ----------
  void _paintMaghrib(Canvas canvas, double w, double h) {
    final rect = Rect.fromLTWH(0, 0, w, h);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2B2A52), // بنفسجي داكن
            Color(0xFF7A3B5E), // عنابي
            Color(0xFFC75B3A), // برتقالي محروق
            Color(0xFFF2A65A), // ذهبي دافئ
          ],
          stops: [0, 0.4, 0.75, 1],
        ).createShader(rect),
    );

    // شمس تغرب — نصفها خلف الأفق
    final sun = Offset(w * 0.5, h * 1.02);
    canvas.drawCircle(sun, w * 0.14, Paint()..color = const Color(0xFFFFC46B));
    canvas.drawCircle(
      sun,
      w * 0.24,
      Paint()
        ..color = const Color(0xFFFFC46B).withOpacity(0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40),
    );

    // نجوم أولى تظهر في الأعلى
    _paintStars(canvas, w, h, opacity: 0.35, maxY: 0.4);
  }

  // ---------- العشاء: سماء ليلية + قمر + درب التبانة + نجوم صليبية + شهب ----------
  void _paintIsha(Canvas canvas, double w, double h) {
    final rect = Rect.fromLTWH(0, 0, w, h);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF04070F), // أسود مزرق عميق
            Color(0xFF0B1428),
            Color(0xFF15223F),
          ],
        ).createShader(rect),
    );

    // درب التبانة الخافت
    _paintMilkyWay(canvas, w, h);

    // قمر هلالي جميل
    _paintMoon(canvas, w, h);

    // أفق المدينة البعيد
    _paintCitySkyline(canvas, w, h);

    // نجوم صليبية متلألئة
    _paintStars(canvas, w, h, opacity: 1.0);

    // شهب تظهر وتختفي ببطء
    _paintMeteors(canvas, w, h);
  }

  // ---------- النجوم الصليبية المتلألئة ----------
  void _paintStars(
    Canvas canvas,
    double w,
    double h, {
    required double opacity,
    double maxY = 0.75,
  }) {
    for (final s in _stars) {
      if (s.y > maxY) continue;
      // تلألؤ ناعم بطيء
      final twinkle =
          0.55 + 0.45 * math.sin(t * 2 * math.pi * s.speed + s.phase);
      final center = Offset(s.x * w, s.y * h);
      final baseR = s.size * (0.9 + 0.5 * twinkle);
      final alpha = opacity * (0.4 + 0.6 * twinkle);
      final big = s.size > 1.8;

      // توهج خارجي ناعم
      canvas.drawCircle(
        center,
        baseR * (big ? 4.2 : 2.6),
        Paint()
          ..color = Colors.white.withOpacity(0.05 * alpha)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );

      // أشعة صليبية (4 أشعة متقاطعة) للنجوم الكبيرة
      if (big) {
        final rayLen = baseR * (2.6 + 1.4 * twinkle);
        final rayPaint = Paint()
          ..color = Colors.white.withOpacity(0.75 * alpha)
          ..strokeWidth = baseR * 0.55
          ..strokeCap = StrokeCap.round;
        // أفقي
        canvas.drawLine(
          Offset(center.dx - rayLen, center.dy),
          Offset(center.dx + rayLen, center.dy),
          rayPaint,
        );
        // عمودي
        canvas.drawLine(
          Offset(center.dx, center.dy - rayLen),
          Offset(center.dx, center.dy + rayLen),
          rayPaint,
        );
      }

      // قلب النجمة المتوهج
      canvas.drawCircle(
        center,
        baseR * 0.9,
        Paint()..color = Colors.white.withOpacity(0.95 * alpha),
      );
      canvas.drawCircle(
        center,
        baseR * 1.7,
        Paint()
          ..color = const Color(0xFFDCE8FF).withOpacity(0.28 * alpha)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
    }
  }

  // ---------- قمر هلالي ذهبي ----------
  void _paintMoon(Canvas canvas, double w, double h) {
    final center = Offset(w * 0.78, h * 0.2);
    final r = w * 0.075;

    // هالة القمر
    canvas.drawCircle(
      center,
      r * 2.4,
      Paint()
        ..color = const Color(0xFFF5E9C4).withOpacity(0.12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
    );

    // قرص القمر
    canvas.drawCircle(
      center,
      r,
      Paint()..color = const Color(0xFFF5E9C4).withOpacity(0.95),
    );

    // إزاحة الظل لعمل الهلال
    final shadowOffset = Offset(r * 0.55, -r * 0.18);
    canvas.drawCircle(
      center + shadowOffset,
      r * 0.92,
      Paint()..color = const Color(0xFF0B1428),
    );

    // حافة مضيئة خفيفة على الهلال
    canvas.drawCircle(
      center + shadowOffset,
      r * 0.92,
      Paint()
        ..color = const Color(0xFF0B1428)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  // ---------- درب التبانة الخافت ----------
  void _paintMilkyWay(Canvas canvas, double w, double h) {
    final path = Path()..moveTo(w * 0.05, h * 0.05);
    // خط متموج عبر السماء
    for (var i = 1; i <= 10; i++) {
      final x = w * (0.05 + i * 0.09);
      final y = h * (0.05 + i * 0.06 + math.sin(i * 1.3) * 0.03);
      path.lineTo(x, y);
    }
    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          colors: [Colors.transparent, Colors.white, Colors.transparent],
        ).createShader(Rect.fromLTWH(0, 0, w, h))
        ..strokeWidth = w * 0.05
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
    );
  }

  // ---------- الشهب: تظهر وتمر وتختفي ببطء ----------
  void _paintMeteors(Canvas canvas, double w, double h) {
    // 3 شهب في أوقات مختلفة من الدورة
    const meteorWindows = [
      (start: 0.05, len: 0.18),
      (start: 0.38, len: 0.22),
      (start: 0.68, len: 0.16),
    ];

    for (final m in meteorWindows) {
      // نافذة ظهور تدريجي: توهج ناعم + اختفاء بطيء
      double appear;
      if (t < m.start) {
        appear = 0;
      } else if (t < m.start + m.len) {
        final local = (t - m.start) / m.len;
        // ارتفاع بطيء ثم هبوط بطيء (منحنى جرسي)
        appear = math.sin(local * math.pi); // 0 → 1 → 0
      } else {
        appear = 0;
      }
      if (appear < 0.02) continue;

      final startX = w * 0.25;
      final endX = w * 0.8;
      final y = h * (0.12 + (m.start * 3) % 1 * 0.3);
      final local = (t - m.start) / m.len;
      final x = startX + (endX - startX) * local;
      final meteorY = y + local * h * 0.06;

      final paint = Paint()
        ..color = Colors.white.withOpacity(0.85 * appear)
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round;

      // ذيل الشهاب — خط متدرج خلفه
      final tailLen = w * 0.14;
      final tail = Path()
        ..moveTo(x, meteorY)
        ..lineTo(x - tailLen, meteorY - tailLen * 0.18);
      canvas.drawPath(
        tail,
        Paint()
          ..color = Colors.white.withOpacity(0.45 * appear)
          ..strokeWidth = 1.2
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );

      // رأس الشهاب المتوهج
      canvas.drawCircle(Offset(x, meteorY), 1.8, paint);
      canvas.drawCircle(
        Offset(x, meteorY),
        4.5,
        Paint()
          ..color = const Color(0xFFBBD6FF).withOpacity(0.35 * appear)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
    }
  }

  // ---------- أفق مدينة ليلية بسيط ----------
  void _paintCitySkyline(Canvas canvas, double w, double h) {
    final paint = Paint()..color = const Color(0xFF05070F).withOpacity(0.75);
    final path = Path();
    path.moveTo(0, h);
    path.lineTo(0, h * 0.88);
    // مباني بأحجام مختلفة
    double x = 0;
    final rnd = math.Random(7);
    while (x < w) {
      final bw = w * (0.04 + rnd.nextDouble() * 0.06);
      final bh = h * (0.05 + rnd.nextDouble() * 0.09);
      path.lineTo(x, h * 0.88 - bh);
      path.lineTo(x + bw, h * 0.88 - bh);
      x += bw;
    }
    path.lineTo(w, h * 0.88);
    path.lineTo(w, h);
    path.close();
    canvas.drawPath(path, paint);

    // نوافذ ذهبية دافئة قليلة
    final winPaint = Paint()..color = const Color(0xFFE3C877).withOpacity(0.5);
    final wrnd = math.Random(11);
    for (var i = 0; i < 18; i++) {
      final wx = wrnd.nextDouble() * w;
      final wy = h * (0.82 + wrnd.nextDouble() * 0.055);
      canvas.drawRect(Rect.fromLTWH(wx, wy, w * 0.006, h * 0.008), winPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SkyPainter old) =>
      old.prayer != prayer || old.t != t || old.isDark != isDark;
}

/// نجمة في السماء
class _Star {
  final double x, y, size, phase, speed;
  const _Star({
    required this.x,
    required this.y,
    required this.size,
    required this.phase,
    required this.speed,
  });
}
