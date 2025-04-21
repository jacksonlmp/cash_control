import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> getCryptoPrice(List<String> cryptoIds) async {
  final ids = cryptoIds.join(',');
  final url = Uri.parse('https://api.coingecko.com/api/v3/simple/price?ids=$ids&vs_currencies=usd');

  try {
    final response = await http.get(url).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao carregar os preços das criptomoedas');
    }
  } catch (e) {
    throw Exception('Erro ao conectar com a API: $e');
  }
}