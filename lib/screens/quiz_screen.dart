import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final double qtdInvicoin = 2; //qntd de Invicoin
  final String lessonTopic = "Investimentos e Poupança"; //tema da aula
  final String question = "Qual é a moeda usada no Brasil?"; //pergunta
  final List<String> options = ["Dólar", "Euro", "Real", "Cruzeiro"]; //alterativas

  String? selectedOption; //alternativa escolhida

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
                    child: ListView.builder(   //alternativas
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: selectedOption == options[index] ? Colors.deepPurpleAccent : Colors.white,
                          child: ListTile(
                            title: Text(
                              options[index],
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
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(           //botao de confirmaçao
                    onPressed: selectedOption != null
                        ? () {
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
