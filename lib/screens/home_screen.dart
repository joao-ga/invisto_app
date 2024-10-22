import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: const Text(
          'Bem-vindo à HomeScreen!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
