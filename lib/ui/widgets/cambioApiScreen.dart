import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cash_control/data/cambioApiService.dart';

class Cambioapiscreen extends StatefulWidget {
  @override
  _CambioapiscreenState createState() => _CambioapiscreenState();
}

class _CambioapiscreenState extends State<Cambioapiscreen> {
  final List<String> baseOptions = ['BRL', 'USD'];
  final List<String> currencies = ['BRL', 'USD', 'EUR', 'BTC', 'ETH', 'JPY'];

  String baseCurrency = 'BRL';
  String targetCurrency = 'USD';

  double conversionRate = 0.0;
  double amount = 1.0;
  String errorMessage = '';
  bool isLoading = false;

  final _controller = TextEditingController(text: '1');
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _fetchRate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _fetchRate() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      if (baseCurrency == targetCurrency) {
        setState(() {
          conversionRate = amount;
          isLoading = false;
        });
        return;
      }

      final data = await getCryptoExchangeRates(
        cryptoIds: ['bitcoin'],
        currencies: [baseCurrency.toLowerCase(), targetCurrency.toLowerCase()],
      );

      final rates = data['bitcoin'] as Map<String, dynamic>;

      final base = baseCurrency.toLowerCase();
      final target = targetCurrency.toLowerCase();

      if (!rates.containsKey(base) || !rates.containsKey(target)) {
        throw Exception('Taxa não disponível');
      }

      final baseRate = (rates[base] as num).toDouble();
      final targetRate = (rates[target] as num).toDouble();

      setState(() {
        conversionRate = (targetRate / baseRate) * amount;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Erro ao buscar taxa de câmbio.';
        isLoading = false;
      });
    }
  }

  void _onAmountChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        amount = double.tryParse(value) ?? 1.0;
      });
      _fetchRate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Conversor de Cripto"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: const Border(bottom: BorderSide(color: Colors.deepPurple, width: 1.5)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Moeda Base:", style: TextStyle(color: Colors.white)),
            DropdownButton<String>(
              dropdownColor: Colors.grey[900],
              value: baseCurrency,
              onChanged: (value) {
                if (value != null) {
                  setState(() => baseCurrency = value);
                  _fetchRate();
                }
              },
              items: baseOptions.map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Text(currency, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text("Converter Para:", style: TextStyle(color: Colors.white)),
            DropdownButton<String>(
              dropdownColor: Colors.grey[900],
              value: targetCurrency,
              onChanged: (value) {
                if (value != null) {
                  setState(() => targetCurrency = value);
                  _fetchRate();
                }
              },
              items: currencies.where((c) => c != baseCurrency).map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Text(currency, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Valor",
                labelStyle: const TextStyle(color: Colors.white),
                enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurpleAccent)),
              ),
              onChanged: _onAmountChanged,
            ),
            const SizedBox(height: 24),
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: const TextStyle(color: Colors.redAccent)),
            if (!isLoading && errorMessage.isEmpty)
              Text(
                "$amount $baseCurrency = ${conversionRate.toStringAsFixed(4)} $targetCurrency",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Center(child: CircularProgressIndicator(color: Colors.deepPurple)),
              ),
          ],
        ),
      ),
    );
  }
}
