import 'dart:convert';
import 'package:http/http.dart' as http;


Future<Map<String, dynamic>> getCryptoExchangeRates({
  List<String> cryptoIds = const [
    'bitcoin',
    'ethereum',
    'solana',
    'binancecoin',
    'ripple'
  ],
  List<String> currencies = const ['brl', 'usd', 'eur', 'btc'],
}) async {
  if (cryptoIds.isEmpty || currencies.isEmpty) {
    throw ArgumentError('Lista de criptomoedas e moedas não pode estar vazia.');
  }

  final ids = cryptoIds.join(',');
  final vsCurrencies = currencies.join(',');
  final url = Uri.parse(
    'https://api.coingecko.com/api/v3/simple/price?ids=$ids&vs_currencies=$vsCurrencies',
  );

  final response = await http.get(url, headers: {
    'Accept': 'application/json',
    'User-Agent': 'cash_control_app/1.0',
  });

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data is Map<String, dynamic>) {
      return data;
    } else {
      throw Exception('Resposta inesperada da API CoinGecko.');
    }
  } else {
    throw Exception('Erro ao obter taxas de câmbio: ${response.statusCode}');
  }
}
