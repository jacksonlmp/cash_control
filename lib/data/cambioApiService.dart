import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getExchangeRates(List<String> symbols, {String base = 'USD'}) async {
  final joinedSymbols = symbols.join(',');
  final url = Uri.parse('https://api.exchangerate.host/latest?base=$base&symbols=$joinedSymbols');

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return Map<String, dynamic>.from(data['rates']);
  } else {
    throw Exception('Erro ao obter taxas de câmbio: ${response.statusCode}');
  }
}
