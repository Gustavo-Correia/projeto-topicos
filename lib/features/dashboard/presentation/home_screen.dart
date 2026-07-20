import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:assinaturas_ninja/features/subscriptions/model/subscription.dart';
import 'package:assinaturas_ninja/features/dashboard/provider/currency_provider.dart';
import 'package:assinaturas_ninja/features/settings/provider/settings_provider.dart';
import 'package:assinaturas_ninja/features/subscriptions/provider/subscription_provider.dart';
import 'package:assinaturas_ninja/routes.dart';
import 'package:assinaturas_ninja/core/theme/app_colors.dart';
import 'package:assinaturas_ninja/core/theme/app_spacing.dart';
import 'package:assinaturas_ninja/core/utils/formatters.dart';
import 'package:assinaturas_ninja/core/widgets/app_card.dart';
import 'package:assinaturas_ninja/features/subscriptions/widgets/category_icon.dart';
import 'package:assinaturas_ninja/core/widgets/brand_mark.dart';
import 'package:assinaturas_ninja/features/subscriptions/widgets/empty_state.dart';
import 'package:assinaturas_ninja/features/subscriptions/presentation/reports_screen.dart';
import 'package:assinaturas_ninja/features/settings/presentation/settings_screen.dart';
import 'package:assinaturas_ninja/features/subscriptions/presentation/subscriptions_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    final pages = [
      const _DashboardPage(),
      const SubscriptionsScreen(),
      const ReportsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        backgroundColor: theme.backgroundSoft,
        indicatorColor: theme.green.withValues(alpha: 0.18),
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt_rounded),
            label: 'Assinaturas',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: 'Relatórios',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune_rounded),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}

class _DashboardPage extends StatelessWidget {
  const _DashboardPage();

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Consumer<SubscriptionProvider>(
      builder: (context, provider, _) {
        if (provider.subscriptions.isEmpty) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 18, 20, 0),
                    child: _Header(),
                  ),
                  Expanded(child: EmptyState(onAdd: () => _openForm(context))),
                ],
              ),
            ),
          );
        }

        final mostExpensive = provider.mostExpensive;
        final nextCharge = provider.upcomingCharges.isNotEmpty ? provider.upcomingCharges.first : null;
        final nextChargeDays = nextCharge == null ? null : provider.daysUntilDue(nextCharge);

        final dueThisWeek = provider.dueThisWeek;

        final displaySettings = context.watch<SettingsProvider>().settings;
        final displayCurrency = context.watch<CurrencyProvider>();
        final usdRate = displayCurrency.usdBrlRate;
        final showUsd = displaySettings.displayCurrency == 'USD' && usdRate != null && usdRate > 0;
        final annualTotal = provider.totalMonthly * 12;
        final annualDisplay = showUsd ? formatUsd(annualTotal / usdRate) : formatMoney(annualTotal);
        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              children: [
                const _Header(),
                const SizedBox(height: AppSpacing.xxl),
                _TotalCard(total: provider.totalMonthly),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: _StatTile(
                        icon: Icons.groups_rounded,
                        label: 'Assinaturas ativas',
                        value: provider.activeCount.toString(),
                        accent: theme.green,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _StatTile(
                        icon: Icons.event_repeat_rounded,
                        label: 'Projeção anual',
                        value: annualDisplay,
                        accent: theme.purple,
                      ),
                    ),
                  ],
                ),
                if (mostExpensive != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  _HighlightTile(
                    subscription: mostExpensive,
                    leading: CategoryIcon(category: mostExpensive.category),
                    overline: 'Assinatura mais cara',
                    trailing: formatMoney(mostExpensive.price),
                    trailingColor: theme.purple,
                  ),
                ],
                if (nextCharge != null && nextChargeDays != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  _HighlightTile(
                    subscription: nextCharge,
                    leading: CategoryIcon(category: nextCharge.category),
                    overline: 'Próxima cobrança',
                    trailing: dueLabel(nextChargeDays),
                    trailingColor: nextChargeDays == 0
                        ? theme.red
                        : nextChargeDays <= 5
                              ? theme.yellow
                              : theme.cyan,
                  ),
                ],
                const SizedBox(height: AppSpacing.xxl),
                _SavingsInsightCard(monthlyTotal: provider.totalMonthly),
                if (dueThisWeek.isNotEmpty) ...[
                  _DueAlert(count: dueThisWeek.length),
                  const SizedBox(height: AppSpacing.xxl),
                ],
                const SectionTitle('Próximas cobranças'),
                const SizedBox(height: AppSpacing.sm + 6),
                _UpcomingChargesList(items: provider.upcomingCharges.take(4).toList()),
                const SizedBox(height: AppSpacing.xxl),
                ElevatedButton.icon(
                  onPressed: () => _openForm(context),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Adicionar assinatura'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openForm(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.subscriptionForm);
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    final userName = context.watch<SettingsProvider>().settings.userName;
    return Row(
      children: [
        const BrandMark(size: 54),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Assinaturas Ninja', maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.displayMedium),
              const SizedBox(height: 2),
              Text(
                userName.isEmpty ? 'Controle seus gastos recorrentes' : 'Olá, $userName',
                style: TextStyle(color: theme.muted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    final settings = context.watch<SettingsProvider>().settings;
    final currency = context.watch<CurrencyProvider>();
    final rate = currency.usdBrlRate;
    final showUsd = settings.displayCurrency == 'USD' && rate != null && rate > 0;
    final displayValue = showUsd ? formatUsd(total / rate) : formatMoney(total);
    final subtitle = showUsd
        ? 'Total das assinaturas ativas • R\$ ${rate.toStringAsFixed(2)}/US\$'
        : 'Total das assinaturas ativas';
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: LinearGradient(
          colors: [theme.green, theme.cyan],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.green.withValues(alpha: 0.18),
            blurRadius: AppSpacing.xxl,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gasto mensal',
                  style: TextStyle(color: theme.textPrimary.withValues(alpha: 0.87), fontSize: 16),
                ),
                const SizedBox(height: AppSpacing.md - 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    displayValue,
                    style: AppTypography.hero.copyWith(color: theme.textPrimary.withValues(alpha: 0.94)),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs + 2),
                Text(
                  subtitle,
                  style: TextStyle(color: theme.textPrimary.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ),
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.textPrimary.withValues(alpha: 0.16),
            ),
            child: Icon(Icons.trending_up_rounded, color: theme.textPrimary.withValues(alpha: 0.7), size: 38),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: theme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withValues(alpha: 0.14),
            ),
            child: Icon(icon, color: accent, size: 19),
          ),
          const SizedBox(height: AppSpacing.md),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTypography.titleMedium.copyWith(color: theme.textPrimary),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.micro.copyWith(color: theme.muted),
          ),
        ],
      ),
    );
  }
}

class _HighlightTile extends StatelessWidget {
  const _HighlightTile({
    required this.subscription,
    required this.leading,
    required this.overline,
    required this.trailing,
    required this.trailingColor,
  });

  final Subscription subscription;
  final Widget leading;
  final String overline;
  final String trailing;
  final Color trailingColor;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.subscriptionDetail,
          arguments: subscription.id,
        );
      },
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md + 2),
        decoration: BoxDecoration(
          color: theme.card,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: theme.border),
        ),
        child: Row(
          children: [
            leading,
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    overline,
                    style: AppTypography.micro.copyWith(color: theme.muted),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subscription.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyLarge.copyWith(color: theme.textPrimary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              trailing,
              style: AppTypography.captionBold.copyWith(color: trailingColor),
            ),
            const SizedBox(width: 2),
            Icon(Icons.chevron_right_rounded, color: theme.muted),
          ],
        ),
      ),
    );
  }
}

class _UpcomingChargesList extends StatelessWidget {
  const _UpcomingChargesList({required this.items});

  final List<Subscription> items;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    if (items.isEmpty) {
      return Text(
        'Nenhuma cobrança ativa no momento.',
        style: TextStyle(color: theme.muted),
      );
    }

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (final item in items) _UpcomingChargeTile(subscription: item),
        ],
      ),
    );
  }
}

class _DueAlert extends StatelessWidget {
  const _DueAlert({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md + 1),
      decoration: BoxDecoration(
        color: theme.yellow.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        border: Border.all(color: theme.yellow.withValues(alpha: 0.36)),
      ),
      child: Row(
        children: [
          Icon(Icons.notifications_active_outlined, color: theme.yellow),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$count cobrança(s) vencem nos próximos 5 dias.',
              style: TextStyle(color: theme.yellow, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _UpcomingChargeTile extends StatelessWidget {
  const _UpcomingChargeTile({required this.subscription});

  final Subscription subscription;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Consumer<SubscriptionProvider>(
      builder: (context, provider, _) {
        final dueSoon = provider.isDueSoon(subscription);
        final dueToday = provider.isDueToday(subscription);
        final color = dueToday
            ? theme.red
            : dueSoon
            ? theme.yellow
            : theme.cyan;

        return InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.subscriptionDetail,
              arguments: subscription.id,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CategoryIcon(category: subscription.category),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subscription.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodyLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatMoney(subscription.price),
                        style: TextStyle(color: theme.muted),
                      ),
                    ],
                  ),
                ),
                Text(
                  'dia ${subscription.dueDay}',
                  style: TextStyle(color: color, fontWeight: FontWeight.w900),
                ),
                Icon(Icons.chevron_right_rounded, color: theme.muted),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Insight card showing the opportunity cost of subscriptions at the
/// current annual Selic rate (Banco Central do Brasil). Hidden when offline.
class _SavingsInsightCard extends StatefulWidget {
  const _SavingsInsightCard({required this.monthlyTotal});

  final double monthlyTotal;

  @override
  State<_SavingsInsightCard> createState() => _SavingsInsightCardState();
}

class _SavingsInsightCardState extends State<_SavingsInsightCard> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      final currency = context.read<CurrencyProvider>();
      if (!currency.selicLoaded) {
        currency.fetchSelic();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Consumer<CurrencyProvider>(
      builder: (context, currency, _) {
        final selic = currency.selicRate;
        final projected = currency.projectedReturn12m(widget.monthlyTotal);
        if (selic == null || projected == null) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.green.withValues(alpha: 0.14),
                  theme.cyan.withValues(alpha: 0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.green.withValues(alpha: 0.35)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.trending_up_rounded, size: 18, color: theme.green),
                    const SizedBox(width: 8),
                    Text(
                      'Oportunidade de economia',
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: theme.green.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Selic ${selic.toStringAsFixed(2)}% a.a.',
                        style: TextStyle(
                          color: theme.green,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Investindo ${formatMoney(widget.monthlyTotal)}/mês na Selic, você teria ${formatMoney(projected)} em 12 meses.',
                  style: TextStyle(color: theme.muted, fontSize: 12.5, height: 1.45),
                ),
                const SizedBox(height: 6),
                Text(
                  'Fonte: Banco Central do Brasil',
                  style: TextStyle(color: theme.muted.withValues(alpha: 0.6), fontSize: 10.5),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

