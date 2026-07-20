import 'package:intl/intl.dart';

final NumberFormat moneyFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

final NumberFormat usdFormatter = NumberFormat.currency(locale: 'en_US', symbol: 'US\$');

String formatMoney(double value) => moneyFormatter.format(value);

String formatUsd(double value) => usdFormatter.format(value);

String dueLabel(int days) {
  if (days == 0) {
    return 'vence hoje';
  }
  if (days == 1) {
    return 'em 1 dia';
  }
  return 'em $days dias';
}
