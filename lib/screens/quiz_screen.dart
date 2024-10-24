import 'package:flutter/material.dart';

class QuizScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.arrow_back, size: 25),
                Image.asset(
                  'assets/images/BlackSemFrase.png',
                  height: 80,
                  width: 100,
                ),
                Icon(Icons.currency_bitcoin, size: 25)
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.purpleAccent, Colors.purple],
                ),
              ),
              ),
            ),
        ],
      ),
    );
  }
}
