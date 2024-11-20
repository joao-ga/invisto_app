import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class StockService {
  final String baseUrl = Platform.isIOS
      ? 'http://localhost:5001/stocks'
      : 'http://10.0.2.2:5001/stocks';

  Future<dynamic> getStock(String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/getLastPrice'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'code': code}),
    );

    final data = json.decode(response.body);

    return data;
  }
}