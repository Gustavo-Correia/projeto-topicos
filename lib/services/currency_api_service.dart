import 'dart:convert';

import 'package:http/http.dart' as http;

/// Fetches financial data from public APIs (AwesomeAPI + Banco Central).
///
/// Returns `null` on any failure (offline, timeout, parse error),
/// so the app degrades gracefully without connectivity.
class CurrencyApiService {
  CurrencyApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _usdBrlUrl = 'https://economia.awesomeapi.com.br/json/last/USD-BRL';
  static const _selicUrl =
      'https://api.bcb.gov.br/dados/serie/bcdata.sgs.11/dados/ultimos/1?formato=json';

  /// Fetches the current USD→BRL exchange rate from AwesomeAPI.
  Future<double?> fetchUsdBrlRate() async {
    try {
      final response = await _client
          .get(Uri.parse(_usdBrlUrl))
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

  /// Fetches the current Selic rate (% a.a.) from Banco Central do Brasil.
  Future<double?> fetchSelicRate() async {
    try {
      final response = await _client
          .get(Uri.parse(_selicUrl))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) {
        return null;
      }

      final json = jsonDecode(response.body) as List<dynamic>;
      if (json.isEmpty) return null;

      final entry = json.first as Map<String, dynamic>;
      final valor = entry['valor'] as String?;
      return valor == null ? null : double.tryParse(valor);
    } catch (_) {
      return null;
    }
  }
}
