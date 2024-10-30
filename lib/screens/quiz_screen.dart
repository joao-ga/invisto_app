import 'package:flutter/material.dart';
import 'dart:async';

class QuizScreen extends StatefulWidget {
  final Map<String, dynamic> quizData;
  QuizScreen({super.key, required this.quizData});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late int qtdInvicoin;
  late String lessonTopic;
  late String question;
  late List<Map<String, dynamic>> options;
  Color color = Colors.deepPurpleAccent;
  Map<String, dynamic>? selectedOption;
  int countdown = 3; // Variável que inicia a contagem regressiva
  bool showAnswers = false; // Variável que mostra as respostas após a contagem

  @override
  void initState() {
    super.initState();
    startCountdown();
    final quiz = widget.quizData['quiz'];

    qtdInvicoin = quiz['addCoins'] ?? 0;
    lessonTopic = quiz['subject'] ?? '';
    question = quiz['question'] ?? '';
    options = (quiz['answers'] as List<dynamic>).map((answer) => (answer as Map<String, dynamic>)).toList();
  }

  void startCountdown() {
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (countdown > 1) {
          countdown--;
        } else {
          countdown = 0;
          showAnswers = true; // Exibe as respostas após a contagem
          timer.cancel(); // Cancela o timer ao final da contagem
        }
      });
    });
  }

  bool confirmarResposta(Map<String, dynamic>? resposta){
   return resposta?['isTrue'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.arrow_back, size: 25),
                Image.asset(
                  'assets/images/BlackSemFrase.png',
                  height: 80,
                  width: 100,
                ),
                Row(
                  children: [
                    Icon(Icons.currency_bitcoin, size: 25),   //!!!COLOCAR FOTO DA MOEDA INVICOIN!!!
                    Text(
                      qtdInvicoin.toString(),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.purpleAccent, Colors.purple],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Quiz Invisto',   //!!!COLOCAR UMA FOTO ESTLIZADA COM ESTA FRASE!!!
                    style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    lessonTopic, //tema da aula
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    question, //pergunta
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child:showAnswers ? ListView.builder(   //alternativas
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: selectedOption == options[index] ? color : Colors.white,
                          child: ListTile(
                            title: Text(
                              options[index]['answer1'],
                              style: TextStyle(fontSize: 18),
                            ),
                            onTap: () {
                              setState(() {
                                selectedOption = options[index];
                              });
                            },
                          ),
                        );
                      },
                    ) : Text(
                      countdown > 0 ? "$countdown" : "Começando...",
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: selectedOption != null
                        ? () {
                      if(confirmarResposta(selectedOption)){
                        // RESPOSTA CERTA
                        color = Colors.green;
                      }else{
                        // RESPOSTA ERRADA
                        color = Colors.red;
                      }
                      print("Resposta confirmada: $selectedOption");
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, backgroundColor: Colors.greenAccent,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      'Confirmar Resposta',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
