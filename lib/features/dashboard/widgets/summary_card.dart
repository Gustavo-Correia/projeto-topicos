import 'package:flutter/material.dart';

import 'package:assinaturas_ninja/core/theme/app_colors.dart';
import 'package:assinaturas_ninja/core/theme/app_spacing.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.subtitle,
    this.accent,
  });

  final IconData icon;
  final String title;
  final String value;
  final String? subtitle;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    final activeAccent = accent ?? theme.cyan;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: theme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: activeAccent, size: 26),
          const Spacer(),
          Text(title, style: AppTypography.caption.copyWith(color: theme.muted)),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.titleLarge,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: activeAccent, fontWeight: FontWeight.w800),
            ),
          ],
        ],
      ),
    );
  }
}
