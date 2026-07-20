import 'package:flutter/material.dart';

import 'package:assinaturas_ninja/features/subscriptions/model/subscription.dart';
import 'package:assinaturas_ninja/core/theme/app_colors.dart';
import 'package:assinaturas_ninja/core/theme/app_spacing.dart';
import 'package:assinaturas_ninja/core/utils/formatters.dart';
import 'package:assinaturas_ninja/features/subscriptions/widgets/category_icon.dart';
import 'package:assinaturas_ninja/core/widgets/status_chip.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({
    super.key,
    required this.subscription,
    required this.daysUntilDue,
    required this.isDueToday,
    required this.isDueSoon,
    required this.onTap,
    this.onMenuSelected,
  });

  final Subscription subscription;
  final int daysUntilDue;
  final bool isDueToday;
  final bool isDueSoon;
  final VoidCallback onTap;
  final ValueChanged<String>? onMenuSelected;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    final dueColor = isDueToday
        ? theme.red
        : isDueSoon
        ? theme.yellow
        : theme.muted;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: theme.card,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isDueToday ? theme.red.withValues(alpha: 0.7) : theme.border,
          ),
        ),
        child: Row(
          children: [
            CategoryIcon(category: subscription.category),
            const SizedBox(width: AppSpacing.sm + 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          subscription.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.titleSmall,
                        ),
                      ),
                      StatusChip(status: subscription.status),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '${subscription.category} • ${formatMoney(subscription.price)}',
                    style: TextStyle(color: theme.muted, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Dia ${subscription.dueDay} • ${dueLabel(daysUntilDue)}',
                    style: TextStyle(color: dueColor, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            PopupMenuButton<String>(
              tooltip: 'Ações',
              onSelected: onMenuSelected,
              icon: Icon(Icons.more_vert_rounded, color: theme.muted),
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'toggle', child: Text('Alterar status')),
                PopupMenuItem(value: 'edit', child: Text('Editar')),
                PopupMenuItem(value: 'delete', child: Text('Excluir')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
