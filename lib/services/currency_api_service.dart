import 'dart:convert';

import 'package:http/http.dart' as http;

/// Fetches the current USD→BRL exchange rate from AwesomeAPI.
///
/// Returns `null` on any failure (offline, timeout, parse error),
/// so the app degrades gracefully without connectivity.
class CurrencyApiService {
  CurrencyApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _url = 'https://economia.awesomeapi.com.br/json/last/USD-BRL';

  Future<double?> fetchUsdBrlRate() async {
    try {
      final response = await _client
          .get(Uri.parse(_url))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) {
        return null;
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final usdBrl = json['USDBRL'] as Map<String, dynamic>?;
      final bid = usdBrl?['bid'] as String?;
      return bid == null ? null : double.tryParse(bid);
    } catch (_) {
      return null;
    }
  }
}
