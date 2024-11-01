import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Image.asset(
            'assets/images/BlackSemFrase.png',
            height: 100,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, size: 30),
            onPressed: () {
              // Função ao clicar no ícone de perfil
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.purple[700], // Cor de background geral
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título "Suas próximas aulas" com padding individual
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding só para os lados, para manter o título no lugar
              child: Text(
                'Suas próximas aulas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Cor do texto branca
                ),
              ),
            ),
            SizedBox(height: 10),

            // Container com fundo roxo claro e largura total para a lista de aulas
            Container(
              color: Colors.purple[200], // Fundo roxo mais claro
              width: double.infinity, // Ocupa toda a largura disponível
              padding: const EdgeInsets.symmetric(vertical: 10.0), // Padding apenas interno
              child: Container(
                height: 150, // Altura do container das aulas
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // Rolagem horizontal
                  padding: EdgeInsets.symmetric(horizontal: 10), // Espaço nas laterais
                  itemCount: 4, // Número de aulas (pode ser dinâmico)
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0), // Espaço entre os círculos
                      child: _buildClassCard("Aula ${index + 1}"), // Exibe Aula 1, Aula 2, Aula 3
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20),

            // Título "Suas simulações de investimentos" com padding individual
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding só para os lados, para manter o título no lugar
              child: Text(
                'Suas simulações de investimentos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),

            Container(
              color: Colors.purple[200],
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: _buildInvestmentSimulation(),
            ),
          ],
        ),
      ),


    );
  }

  // Widget para exibir as aulas (card) como botões com animação de clique personalizada
  Widget _buildClassCard(String className) {
    return AspectRatio(
      aspectRatio: 1, // Garante que o contêiner seja quadrado
      child: Material(
        color: Colors.purple[700], // Cor de fundo do círculo
        borderRadius: BorderRadius.circular(100), // Define bordas arredondadas para o Material
        child: InkWell(
          onTap: () {
            print('$className foi clicado');
          },
          splashColor: Colors.purple[300], // Cor da ondulação (ripple effect)
          highlightColor: Colors.purple[200], // Cor de destaque ao pressionar
          borderRadius: BorderRadius.circular(100), // Define o mesmo borderRadius para o InkWell
          child: Container(
            margin: EdgeInsets.only(right: 10),
            child: Center(
              child: Text(
                className,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }



  // Widget para exibir a simulação de investimento
  Widget _buildInvestmentSimulation() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Variação: 5%",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Rentabilidade: 12%",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Icon(Icons.show_chart, color: Colors.green, size: 80), // Exemplo de gráfico
          ],
        ),
      ),
    );
  }
}