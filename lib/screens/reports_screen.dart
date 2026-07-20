import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../providers/subscription_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_spacing.dart';
import '../utils/formatters.dart';
import '../widgets/app_card.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<SubscriptionProvider, SettingsProvider>(
      builder: (context, subscriptions, settings, _) {
        final categoryEntries = subscriptions.categoryTotals.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final highestCategoryAmount = categoryEntries.isEmpty ? 1.0 : categoryEntries.first.value;
        final budget = settings.settings.monthlyBudget;
        final budgetRatio = budget == null || budget <= 0 ? null : subscriptions.totalMonthly / budget;

        final theme = AppColors.of(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Relatórios', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.screenPadding, 10, AppSpacing.screenPadding, 26),
              children: [
                const SectionTitle('Panorama financeiro', style: AppTypography.headingLarge),
                const SizedBox(height: AppSpacing.sm + 6),
                Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        label: 'Por ano',
                        value: formatMoney(subscriptions.annualActiveTotal),
                        icon: Icons.calendar_view_month_rounded,
                        color: theme.cyan,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MetricCard(
                        label: 'Economia possível',
                        value: formatMoney(subscriptions.potentialMonthlySavings),
                        icon: Icons.savings_rounded,
                        color: theme.green,
                      ),
                    ),
                  ],
                ),
                if (budget != null) ...[
                  const SizedBox(height: AppSpacing.sm + 6),
                  _BudgetCard(
                    budget: budget,
                    spent: subscriptions.totalMonthly,
                    ratio: budgetRatio!,
                  ),
                ],
                const SizedBox(height: AppSpacing.xxxl - 2),
                const SectionTitle('Gastos por categoria', style: AppTypography.headingSmall),
                const SizedBox(height: AppSpacing.sm + 6),
                if (categoryEntries.isEmpty)
                  const _ReportEmptyState()
                else
                  AppCard(
                    padding: const EdgeInsets.all(AppSpacing.md + 6),
                    child: Column(
                      children: categoryEntries
                          .map(
                            (entry) => _CategoryBar(
                              category: entry.key,
                              total: entry.value,
                              progress: entry.value / highestCategoryAmount,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                const SizedBox(height: AppSpacing.xxxl - 2),
                const SectionTitle('Insights', style: AppTypography.headingSmall),
                const SizedBox(height: AppSpacing.md),
                _InsightTile(
                  icon: Icons.insights_rounded,
                  text: subscriptions.topCategoryName == null
                      ? 'Cadastre assinaturas ativas para descobrir sua principal categoria.'
                      : '${subscriptions.topCategoryName} é a categoria com maior custo ativo.',
                ),
                _InsightTile(
                  icon: Icons.pause_circle_outline_rounded,
                  text: subscriptions.inactiveCount == 0
                      ? 'Nenhuma assinatura pausada ou cancelada cadastrada.'
                      : '${subscriptions.inactiveCount} assinatura(s) fora do total mensal.',
                ),
                _InsightTile(
                  icon: Icons.event_rounded,
                  text: subscriptions.dueThisWeek.isEmpty
                      ? 'Nenhuma cobrança ativa vence nos próximos 5 dias.'
                      : '${subscriptions.dueThisWeek.length} cobrança(s) vencem nos próximos 5 dias.',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.sm + 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: AppSpacing.sm + 6),
          Text(label, style: AppTypography.caption.copyWith(color: theme.muted)),
          const SizedBox(height: AppSpacing.xs + 1),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: AppTypography.titleLarge),
          ),
        ],
      ),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  const _BudgetCard({
    required this.budget,
    required this.spent,
    required this.ratio,
  });

  final double budget;
  final double spent;
  final double ratio;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    final cappedRatio = ratio.clamp(0.0, 1.0);
    final exceeded = ratio > 1;
    final color = exceeded ? theme.red : theme.green;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md + 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('Meta mensal', style: AppTypography.bodyLarge),
              ),
              Text('${formatMoney(spent)} / ${formatMoney(budget)}', style: TextStyle(color: color)),
            ],
          ),
          const SizedBox(height: AppSpacing.md + 1),
          LinearProgressIndicator(
            value: cappedRatio,
            minHeight: 8,
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            backgroundColor: theme.cardLight,
            color: color,
          ),
          if (exceeded) ...[
            const SizedBox(height: AppSpacing.md - 2),
            Text('Sua meta mensal foi ultrapassada.', style: TextStyle(color: theme.red)),
          ],
        ],
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({
    required this.category,
    required this.total,
    required this.progress,
  });

  final String category;
  final double total;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md + 3),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text(category, style: AppTypography.bodyLarge)),
              Text(formatMoney(total), style: TextStyle(color: theme.muted)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            backgroundColor: theme.cardLight,
            color: theme.cyan,
          ),
        ],
      ),
    );
  }
}

class _InsightTile extends StatelessWidget {
  const _InsightTile({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return AppCard(
      radius: AppSpacing.lg,
      margin: const EdgeInsets.only(bottom: AppSpacing.md - 2),
      padding: const EdgeInsets.all(AppSpacing.sm + 6),
      child: Row(
        children: [
          Icon(icon, color: theme.purple),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(text, style: const TextStyle(height: 1.3))),
        ],
      ),
    );
  }
}

class _ReportEmptyState extends StatelessWidget {
  const _ReportEmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 26),
      child: Text(
        'As categorias aparecerão aqui quando houver assinaturas ativas.',
        style: TextStyle(color: theme.muted),
      ),
    );
  }
}
