import 'dart:io';

import 'package:flutter/material.dart';
import 'package:invisto_app/services/stock-service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../services/coin-service.dart';

class InvestmentScreen extends StatefulWidget {
  @override
  _InvestmentScreenState createState() => _InvestmentScreenState();
}

class _InvestmentScreenState extends State<InvestmentScreen> {
  late final CoinService _coinService;

  int qtdInvicoin = 0;

  @override
  void initState() {
    super.initState();
    _coinService = CoinService();
    _getCoin();
  }

  Future<void> _getCoin() async {
    final coin = await _coinService.fetchUserCoins();
    if (coin != null) {
      setState(() {
        qtdInvicoin = coin;
      });
    } else {
      print("Erro ao buscar as moedas.");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Image.asset(
          'assets/images/BlackSemFrase.png',
          height: 100,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                Text(
                  qtdInvicoin.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 6),
                Image.asset(
                  'assets/images/invicoin.png',
                  height: 25,
                  width: 25,
                ),
              ],
            ),
          ),
        ],
        backgroundColor: Colors.grey[300],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purpleAccent, Colors.purple],
          ),
        ),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            CompanyCard(stockCode: 'AAPL'),
            CompanyCard(stockCode: 'AMZN'),
            CompanyCard(stockCode: 'NKE'),
            CompanyCard(stockCode: 'DIS'),
            CompanyCard(stockCode: 'TSLA'),
            CompanyCard(stockCode: 'NVDA'),
          ],
        ),
      ),
    );
  }
}

class CompanyCard extends StatelessWidget {
  final String stockCode;
  String high = '';
  String low = '';
  String price = '';

  CompanyCard({super.key, required this.stockCode});

  final String baseUrl = Platform.isIOS
      ? 'http://localhost:5001/stocks'
      : 'http://10.0.2.2:5001/stocks';

  Future<dynamic> getStock(String code) async {
    print("getStock");
    final response = await http.post(
      Uri.parse('$baseUrl/getLastPrice'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'code': code}),
    );
    final data = json.decode(response.body);
    print("Data: $data");
    return data;
  }

  Future<void> fetchStockData() async {
    print("fetchStockData");
    final stock = await getStock(stockCode);
    if (stock != null) {
        high = stock[0]['high'].toString();
        low = stock[0]['low'].toString();
        price = stock[0]['last'].toString();
    } else {
      print("Erro ao carregar os dados.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await fetchStockData();
        _showInvestmentDialog(context, stockCode, high, low, price);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            stockCode,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

void _showInvestmentDialog(BuildContext context, String stockCode, String high, String low, String price) {
  int quantity = 1;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(
              stockCode,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Informações do diálogo
                Text("Alta: $high"),
                Text("Baixa: $low"),
                Text("Preço: \$ $price"),
                const SizedBox(height: 100),
                const SizedBox(width: 300),

                // Botões de controle de quantidade
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (quantity > 1) {
                          setState(() {
                            quantity--;
                          });
                        }
                      },
                      icon: const Icon(Icons.remove),
                    ),
                    Text(
                      '$quantity',
                      style: const TextStyle(fontSize: 18),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Botões de ação usando Wrap para evitar overflow
                // Botões de ação usando Row para centralizar e espaçar uniformemente
                // Botões de ação usando Row para centralizar e espaçar uniformemente
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      height: 35,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Vender",
                          style: TextStyle(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12), // Espaçamento entre os botões
                    SizedBox(
                      width: 90,
                      height: 35,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Comprar",
                          style: TextStyle(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}