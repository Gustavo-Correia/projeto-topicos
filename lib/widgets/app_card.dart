import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_spacing.dart';

/// Reusable card container that replaces the repeated
/// Container + BoxDecoration(color: card, borderRadius, border) pattern.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.radius = AppRadius.lg,
    this.borderColor,
    this.color,
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? borderColor;
  final Color? color;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? theme.card,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor ?? theme.border),
      ),
      child: child,
    );
  }
}

/// Section heading used across screens ("Próximas cobranças", "Insights", etc.)
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: style ?? AppTypography.headingMedium);
  }
}
