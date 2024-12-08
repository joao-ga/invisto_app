import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

String? uid = "";

class UserService {
  UserService(){
    uid = FirebaseAuth.instance.currentUser?.uid;
  }

  final String baseUrl = Platform.isIOS
      ? 'http://localhost:5001/users'
      : 'http://10.0.2.2:5001/users';

  Future<bool> fetchAddCoin(int coins) async {

    final response = await http.post(
      Uri.parse('$baseUrl/addcoins'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'uid': uid, 'coins': coins}),
    );

    return response.statusCode == 200;
  }

  Future<double?> fetchUserCoins() async {
    final response = await http.post(
      Uri.parse('$baseUrl/getuserdata'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'uid': uid}),
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final coin = responseData['data']['coin'];

      if (coin is int) {
        return coin.toDouble();
      } else if (coin is double) {
        return coin;
      } else {
        print("Formato inesperado para o saldo de moedas.");
        return null;
      }
    } else {
      print("Erro ao buscar o saldo de moedas.");
      return null;
    }
  }


  Future<String?> fetchUserRanking() async {

    final response = await http.post(
      Uri.parse('$baseUrl/getuserdata'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'uid': uid}),
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      return responseData['data']['ranking_id'];
    } else {
      print("Erro ao buscar o ranking.");
      return null;
    }
  }

  Future<dynamic> fetchUserStocks() async {
    final response = await http.post(
      Uri.parse('$baseUrl/getuserdata'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'uid': uid}),
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);

      // Verifique se 'stocks' existe e é uma lista
      if (responseData['data'] != null &&
          responseData['data']['stocks'] is List) {
        final stocks = responseData['data']['stocks'] as List;

        // Converta para List<String>
        return stocks.map((e) => e);
      } else {
        print("Erro: Dados de 'stocks' ausentes ou no formato incorreto.");
        return [];
      }
    } else {
      print("Erro: Resposta com status ${response.statusCode}");
      return [];
    }

  }

}
