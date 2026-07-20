import 'package:flutter/material.dart';

import 'package:assinaturas_ninja/features/subscriptions/model/subscription.dart';
import 'package:assinaturas_ninja/core/theme/app_colors.dart';
import 'package:assinaturas_ninja/core/theme/app_spacing.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final SubscriptionStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    final color = switch (status) {
      SubscriptionStatus.active => theme.green,
      SubscriptionStatus.paused => theme.yellow,
      SubscriptionStatus.canceled => theme.red,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md - 2, vertical: AppSpacing.xs + 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: AppRadius.chip,
        border: Border.all(color: color.withValues(alpha: 0.55)),
      ),
      child: Text(
        status.label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w800),
      ),
    );
  }
}
