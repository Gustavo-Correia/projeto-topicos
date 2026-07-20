import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/subscription.dart';
import '../providers/subscription_provider.dart';
import '../routes.dart';
import '../utils/app_colors.dart';
import '../utils/app_spacing.dart';
import '../utils/formatters.dart';
import '../widgets/app_card.dart';
import '../widgets/category_icon.dart';
import '../widgets/status_chip.dart';

class SubscriptionDetailScreen extends StatelessWidget {
  const SubscriptionDetailScreen({super.key, required this.subscriptionId});

  final String subscriptionId;

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, provider, _) {
        final subscription = provider.subscriptions
            .where((item) => item.id == subscriptionId)
            .cast<Subscription?>()
            .firstOrNull;

        if (subscription == null) {
          return const Scaffold(
            body: Center(child: Text('Assinatura não encontrada.')),
          );
        }

        final theme = AppColors.of(context);
        final daysUntilDue = provider.daysUntilDue(subscription);
        final dueToday = provider.isDueToday(subscription);
        final dueSoon = provider.isDueSoon(subscription);
        final dueColor = dueToday
            ? theme.red
            : dueSoon
            ? theme.yellow
            : theme.cyan;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detalhes', style: TextStyle(fontWeight: FontWeight.w900)),
            actions: [
              IconButton(
                tooltip: 'Editar',
                onPressed: () => Navigator.of(context).pushNamed(
                  AppRoutes.subscriptionForm,
                  arguments: subscription,
                ),
                icon: const Icon(Icons.edit_rounded),
              ),
            ],
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.screenPadding, 12, AppSpacing.screenPadding, AppSpacing.xxxl),
              children: [
                AppCard(
                  padding: const EdgeInsets.all(AppSpacing.xxl - 2),
                  radius: AppSpacing.xxxl - 2,
                  borderColor: dueToday ? theme.red.withValues(alpha: 0.7) : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CategoryIcon(category: subscription.category, size: 58),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subscription.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                StatusChip(status: subscription.status),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl - 2),
                      Text(
                        formatMoney(subscription.price),
                        style: AppTypography.priceHero,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Cobrança dia ${subscription.dueDay} • ${dueLabel(daysUntilDue)}',
                        style: TextStyle(color: dueColor, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md + 6),
                _InfoTile(
                  icon: Icons.category_rounded,
                  label: 'Categoria',
                  value: subscription.category,
                ),
                _InfoTile(
                  icon: Icons.credit_card_rounded,
                  label: 'Pagamento',
                  value: subscription.paymentMethod,
                ),
                _InfoTile(
                  icon: Icons.notes_rounded,
                  label: 'Observações',
                  value: subscription.notes.isEmpty ? 'Sem observações.' : subscription.notes,
                ),
                const SizedBox(height: AppSpacing.xxl),
                ElevatedButton.icon(
                  onPressed: () => provider.changeStatus(
                    subscription.id,
                    subscription.status == SubscriptionStatus.active
                        ? SubscriptionStatus.paused
                        : SubscriptionStatus.active,
                  ),
                  icon: Icon(
                    subscription.status == SubscriptionStatus.active
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                  ),
                  label: Text(
                    subscription.status == SubscriptionStatus.active
                        ? 'Pausar assinatura'
                        : 'Ativar assinatura',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                OutlinedButton.icon(
                  onPressed: () => _confirmDelete(context, provider, subscription),
                  icon: const Icon(Icons.delete_rounded),
                  label: const Text('Excluir assinatura'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.red,
                    side: BorderSide(color: theme.red),
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    SubscriptionProvider provider,
    Subscription subscription,
  ) async {
    final theme = AppColors.of(context, listen: false);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir assinatura?'),
        content: Text('Deseja remover ${subscription.name} da sua lista?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Excluir', style: TextStyle(color: theme.red)),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    await provider.deleteSubscription(subscription.id);

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Icon(icon, color: theme.cyan),
          const SizedBox(width: AppSpacing.sm + 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.overline.copyWith(color: theme.muted)),
                const SizedBox(height: AppSpacing.xs),
                Text(value, style: AppTypography.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
