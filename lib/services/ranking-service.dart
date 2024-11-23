import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

String? uid = FirebaseAuth.instance.currentUser?.uid;

class RankingService {
  final String baseUrl = Platform.isIOS
      ? 'http://localhost:5001/ranking'
      : 'http://10.0.2.2:5001/ranking';

  Future<bool> createRanking() async {
    final response = await http.post(
      Uri.parse('$baseUrl/createranking'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'uid': uid}),
    );

    return response.statusCode == 201;
  }

  Future<bool> enterRanking(String rankingId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/enterranking'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'uid': uid, 'ranking': rankingId}),
    );

    return response.statusCode == 200;
  }

  Future<List<Map<String, dynamic>>> getRanking(String rankingId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/getranking'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'ranking': rankingId}),
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);

      // Verifique se 'data' existe e é uma lista
      if (responseData['data'] != null && responseData['data'] is List) {
        final rankingList = responseData['data'] as List;

        // Converta para List<Map<String, dynamic>>
        return rankingList.cast<Map<String, dynamic>>();
      } else {
        print("Ranking vazio");
        return [];
      }
    } else {
      print("Erro: Resposta com status ${response.statusCode}");
      return [];
    }
  }

}
