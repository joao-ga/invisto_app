import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:invisto_app/screens/quiz_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LessonScreen extends StatefulWidget {
  @override
  _LessonPageState createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonScreen> {
  String title = '';
  String introduction = '';
  String content = '';
  String subject = '';
  int qtdInvicoin = 250;

  @override
  void initState() {
    super.initState();
    fetchLessonData();
  }

  // Função para buscar os dados da aula da API
  Future<void> fetchLessonData() async {
    final String baseUrl = Platform.isIOS
        ? 'http://localhost:5001/lessons/lesson'
        : 'http://10.0.2.2:5001/lessons/lesson';

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'subject': 'moeda'}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        title = data['lesson']['title'];
        introduction = data['lesson']['introduction'];
        content = data['lesson']['content'];
        subject = data['lesson']['subject'];
      });
    } else {
      print("Erro ao carregar os dados.");
    }
  }

  Future<void> fetchAddCoin() async {
    final String baseUrl = Platform.isIOS
        ? 'http://localhost:5001/users/addcoins'
        : 'http://10.0.2.2:5001/users/addcoins';

    String? uid = FirebaseAuth.instance.currentUser?.uid;

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'uid': '$uid', 'coins': 50}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Você ganhou 50 Invicoins!')),
      );
    } else {
      print("Erro ao carregar os dados.");
    }
  }

  Future<Map<String, dynamic>> fetchQuiz() async {
    final String baseUrl = Platform.isIOS
        ? 'http://localhost:5001/quizzes/quiz'
        : 'http://10.0.2.2:5001/quizzes/quiz';

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'subject': 'Moeda'}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao carregar o quiz');
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
      body: SingleChildScrollView(
        child: Container(
          color: Colors.purple,
          width: double.infinity,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title.isEmpty ? 'TÍTULO DA AULA' : title.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      introduction.isEmpty ? 'INTRODUÇÃO' : introduction,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      content.isEmpty ? 'CONTEÚDO' : content,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await fetchAddCoin();
                      Navigator.of(context).pop();
                    },
                    child: Text('ENCERRAR'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final quizData = await fetchQuiz();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizScreen(quizData: quizData),
                          ),
                        );
                      } catch (e) {
                        print('Erro ao carregar o quiz: $e');
                      }
                    },
                    child: Text('QUIZ'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}