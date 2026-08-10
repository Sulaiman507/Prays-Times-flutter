import 'dart:async';

import 'package:flutter/material.dart';

import '../providers/prayer_provider.dart';
import '../theme/app_theme.dart';

/// عدّاد تنازلي أنيق للصلاة القادمة — يتحدث كل ثانية
class CountdownTimer extends StatelessWidget {
  final PrayerProvider provider;

  const CountdownTimer({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final remaining = provider.remainingToNext;
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    final seconds = remaining.inSeconds % 60;

    // بطاقة رقمية لكل وحدة
    Widget unit(String value, String label) {
      return Container(
        width: 64,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.navyLight.withOpacity(0.9),
              AppColors.navyDeep.withOpacity(0.95),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.gold.withOpacity(0.25)),
          boxShadow: [
            BoxShadow(
              color: AppColors.navyDeep.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value.padLeft(2, '0'),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.goldLight,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        unit(hours.toString(), 'ساعة'),
        const SizedBox(width: 10),
        _colon(),
        const SizedBox(width: 10),
        unit(minutes.toString(), 'دقيقة'),
        const SizedBox(width: 10),
        _colon(),
        const SizedBox(width: 10),
        unit(seconds.toString(), 'ثانية'),
      ],
    );
  }

  Widget _colon() => const Text(
    ':',
    style: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.bold,
      color: AppColors.gold,
    ),
  );
}
