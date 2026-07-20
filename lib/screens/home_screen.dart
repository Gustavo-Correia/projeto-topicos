import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/subscription.dart';
import '../providers/currency_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/subscription_provider.dart';
import '../routes.dart';
import '../utils/app_colors.dart';
import '../utils/app_spacing.dart';
import '../utils/formatters.dart';
import '../widgets/app_card.dart';
import '../widgets/category_icon.dart';
import '../widgets/brand_mark.dart';
import '../widgets/empty_state.dart';
import '../widgets/summary_card.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';
import 'subscriptions_screen.dart';

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
        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              children: [
                const _Header(),
                const SizedBox(height: AppSpacing.xxl),
                _TotalCard(total: provider.totalMonthly),
                const SizedBox(height: AppSpacing.sm),
                const _ExchangeRateChip(),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  height: 174,
                  child: Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          icon: Icons.groups_rounded,
                          title: 'Ativas',
                          value: provider.activeCount.toString(),
                          accent: theme.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SummaryCard(
                          icon: Icons.star_rounded,
                          title: 'Mais cara',
                          value: mostExpensive?.name ?? '-',
                          subtitle: mostExpensive == null ? null : formatMoney(mostExpensive.price),
                          accent: theme.purple,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SummaryCard(
                          icon: Icons.calendar_month_rounded,
                          title: 'Próxima',
                          value: nextCharge?.name ?? '-',
                          subtitle: nextChargeDays == null ? null : dueLabel(nextChargeDays),
                          accent: theme.cyan,
                        ),
                      ),
                    ],
                  ),
                ),
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
                    formatMoney(total),
                    style: AppTypography.hero.copyWith(color: theme.textPrimary.withValues(alpha: 0.94)),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs + 2),
                Text(
                  'Total das assinaturas ativas',
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
/// current Selic rate (Banco Central do Brasil). Hidden when offline.
class _SavingsInsightCard extends StatelessWidget {
  const _SavingsInsightCard({required this.monthlyTotal});

  final double monthlyTotal;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Consumer<CurrencyProvider>(
      builder: (context, currency, _) {
        final selic = currency.selicRate;
        final projected = currency.projectedReturn12m(monthlyTotal);
        if (selic == null || projected == null) {
          return const SizedBox.shrink();
        }
        return Container(
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
                'Investindo ${formatMoney(monthlyTotal)}/mês na Selic, você teria ${formatMoney(projected)} em 12 meses.',
                style: TextStyle(color: theme.muted, fontSize: 12.5, height: 1.45),
              ),
              const SizedBox(height: 6),
              Text(
                'Fonte: Banco Central do Brasil',
                style: TextStyle(color: theme.muted.withValues(alpha: 0.6), fontSize: 10.5),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Displays the current USD→BRL rate fetched from AwesomeAPI.
/// Hidden when offline or while loading — no error shown.
class _ExchangeRateChip extends StatefulWidget {
  const _ExchangeRateChip();

  @override
  State<_ExchangeRateChip> createState() => _ExchangeRateChipState();
}

class _ExchangeRateChipState extends State<_ExchangeRateChip> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      final currency = context.read<CurrencyProvider>();
      if (!currency.getLoaded) {
        currency.fetchRate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Consumer<CurrencyProvider>(
      builder: (context, currency, _) {
        final rate = currency.usdBrlRate;
        if (rate == null) {
          return const SizedBox.shrink();
        }
        return Row(
          children: [
            Icon(Icons.currency_exchange_rounded, size: 16, color: theme.muted),
            const SizedBox(width: 6),
            Text(
              'USD → BRL: R\$ ${rate.toStringAsFixed(2)}',
              style: TextStyle(color: theme.muted, fontSize: 12),
            ),
            const SizedBox(width: 6),
            Text(
              '(AwesomeAPI)',
              style: TextStyle(color: theme.muted.withValues(alpha: 0.6), fontSize: 11),
            ),
          ],
        );
      },
    );
  }
}
