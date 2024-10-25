import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LessonScreen extends StatefulWidget {
  @override
  _LessonPageState createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonScreen> {
  String title = '';
  String introduction = '';
  String content = '';
  String subject = '';

  @override
  void initState() {
    super.initState();
    fetchLessonData();
  }

  // Função para buscar os dados da aula da API
  Future<void> fetchLessonData() async {
    final String baseUrl = Platform.isIOS
        ? 'http://localhost:5001/users/registration'
        : 'http://10.0.2.2:5001/users/registration';

    final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'subject': 'teste'}),
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

  // Função para buscar o quiz referente ao subject
  Future<Map<String, dynamic>> fetchQuiz() async {
    final response = await http.post(
      Uri.parse('http://localhost:5001/quizzes/quiz'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'subject': 'Moeda'}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Retorna o quiz
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
          'assets/BlackSemFrase.png',
          height: 40,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.star_border),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        color: Colors.purple,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            Text(
              introduction.isEmpty ? 'INTRODUÇÃO' : introduction.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              content.isEmpty ? 'CONTEÚDO' : content.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Ação do botão encerrar
                  },
                  child: Text('ENCERRAR'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Substitui 'primary'
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
                          builder: (context) => QuizPage(quizData: quizData),
                        ),
                      );
                    } catch (e) {
                      print('Erro ao carregar o quiz: $e');
                    }
                  },
                  child: Text('QUIZ'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Substitui 'primary'
                    foregroundColor: Colors.black, // Substitui 'onPrimary'
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
    );
  }
}

class QuizPage extends StatelessWidget {
  final Map<String, dynamic> quizData;

  QuizPage({required this.quizData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Perguntas do Quiz:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: quizData['questions'].length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(quizData['questions'][index]['question']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}