import 'package:flutter/material.dart';
import 'package:cash_control/data/atualidadeService.dart'; // Supondo que a função getCryptoPrice esteja aqui

class AtualidadeScreen extends StatefulWidget {
  @override
  _AtualidadeScreenState createState() => _AtualidadeScreenState();
}

class _AtualidadeScreenState extends State<AtualidadeScreen> {
  Map<String, dynamic> cryptoPrices = {};
  bool isLoading = true;
  String errorMessage = '';

  // Função para buscar os preços das criptos
  void _fetchCryptoPrices() async {
    try {
      var prices = await getCryptoPrice([
        'bitcoin',
        'ethereum',
        'binancecoin',  // BNB
        'solana',       // Solana
        'ripple'        // XRP
      ]);
      setState(() {
        cryptoPrices = prices;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Erro ao carregar os preços. Tente novamente mais tarde.';
      });
      print("Erro ao carregar preços: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCryptoPrices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Atualidade - Cripto Preços"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: cryptoPrices.keys.length,
                itemBuilder: (context, index) {
                  String cryptoName = cryptoPrices.keys.elementAt(index);
                  double price = cryptoPrices[cryptoName]['usd'] ?? 0.0;
                  return ListTile(
                    title: Text(cryptoName[0].toUpperCase() + cryptoName.substring(1)),
                    trailing: Text('\$${price.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _fetchCryptoPrices,  // Atualizar os preços
              child: Text("Atualizar Preços"),
            ),
          ],
        ),
      ),
    );
  }
}
