import 'package:flutter/material.dart';
import 'package:cash_control/data/cambioApiService.dart';

class Cambioapiscreen extends StatefulWidget {
  @override
  _CambioapiscreenState createState() => _CambioapiscreenState();
}

class _CambioapiscreenState extends State<Cambioapiscreen> {
  Map<String, dynamic> exchangeRates = {};
  bool isLoading = true;
  String errorMessage = '';

  void _fetchExchangeRates() async {
    try {
      var rates = await getExchangeRates(
        ['BRL', 'EUR', 'BTC', 'ETH', 'JPY'],
        base: 'USD',
      );

      setState(() {
        exchangeRates = rates;
        isLoading = false;
        errorMessage = '';
      });
    } catch (e) {
      print('Erro ao buscar taxas: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Erro ao carregar as taxas de câmbio.';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchExchangeRates();
  }

  Icon _getCurrencyIcon(String symbol) {
    switch (symbol) {
      case 'BRL':
        return const Icon(Icons.attach_money, color: Colors.green);
      case 'EUR':
        return const Icon(Icons.euro, color: Colors.indigo);
      case 'BTC':
        return const Icon(Icons.currency_bitcoin, color: Colors.orange);
      case 'ETH':
        return const Icon(Icons.device_hub, color: Colors.purple);
      case 'JPY':
        return const Icon(Icons.money, color: Colors.redAccent);
      default:
        return const Icon(Icons.attach_money);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Taxas de Câmbio")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  errorMessage,
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: exchangeRates.length,
                itemBuilder: (context, index) {
                  String symbol = exchangeRates.keys.elementAt(index);
                  double rate = (exchangeRates[symbol] as num).toDouble();

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: _getCurrencyIcon(symbol),
                      title: Text(
                        '1 USD = $rate $symbol',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(Icons.show_chart,
                          color: Colors.blueAccent),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _fetchExchangeRates,
              icon: const Icon(Icons.refresh),
              label: const Text("Atualizar Taxas"),
            ),
          ],
        ),
      ),
    );
  }
}
