import 'package:flutter/material.dart';
import 'package:invisto_app/services/lesson-service.dart';
import '../services/user-service.dart';
import 'lesson_screen.dart';
import 'investment_screen.dart'; // Importe a InvestmentScreen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final UserService _userService;
  late final LessonService _lessonService;
  List<dynamic> lessons = [];
  late int qtdInvicoin;

  // Simula se o usuário está em um ranking
  bool isInRanking = false;

  @override
  void initState() {
    super.initState();
    _userService = UserService();
    _lessonService = LessonService();
    _getCoin();
    allLessons();
  }

  Future<void> _getCoin() async {
    final coin = await _userService.fetchUserCoins();
    if (coin != null) {
      setState(() {
        qtdInvicoin = coin;
      });
      print("Sucesso ao buscar as moedas.");
    } else {
      print("Erro ao buscar as moedas.");
    }
  }

  Future<void> allLessons() async {
    final fetchedLessons = await _lessonService.getAllLessons();
    if (fetchedLessons != null) {
      setState(() {
        lessons = fetchedLessons;
      });
    }
  }

  void showJoinRankingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Se juntar a um ranking"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha o diálogo atual
                  showParticipateDialog(); // Abre o próximo diálogo
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[900],
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
                child: Text(
                  "Participar de ranking",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isInRanking = true; // Simula que o usuário criou ou entrou em um ranking
                  });
                  Navigator.of(context).pop(); // Fecha o diálogo
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[700],
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
                child: Text(
                  "Criar um ranking",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }

  void showParticipateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Participar de ranking"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Código de convite",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isInRanking = true; // Simula que o usuário entrou no ranking
                });
                Navigator.of(context).pop(); // Fecha o diálogo
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Você entrou no ranking!")),
                );
              },
              child: Text("Entrar"),
            ),
          ],
        );
      },
    );
  }

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
        color: Colors.purple[700], // Define o fundo roxo
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saldo do usuário
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Text(
                'Saldo: R\$Valor',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            // Próximas aulas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Suas próximas aulas',
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
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                height: 150, // Altura fixa da área das aulas
                child: lessons.isNotEmpty
                    ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  itemCount: lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = lessons[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: _buildClassCard(lesson),
                    );
                  },
                )
                    : Center(
                  child: Text(
                    "Nenhuma aula disponível.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // Botão Investir
            SizedBox(height: 10),

            Container(
              color: Colors.purple[200],
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: _buildInvestmentSimulation(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InvestmentScreen(type: 'stocks'),
                          ),
                        );
                      },
                      child: Text('Investimentos'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InvestmentScreen(type: 'myStocks'),
                          ),
                        );
                      },
                      child: Text('Meus Investimentos'),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

            // Botão ou ranking
            if (!isInRanking)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: showJoinRankingDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[900],
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      "Se juntar a um ranking",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

            // Renderiza o ranking apenas se isInRanking for true
            if (isInRanking)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ranking",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: List.generate(7, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            height: 40, // Altura reduzida para o ranking
                            decoration: BoxDecoration(
                              color: Colors.purple[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Text(
                                  "${index + 1}° -",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassCard(dynamic lesson) => AspectRatio(
    aspectRatio: 1,
    child: Material(
      child: InkWell(
        onTap: () {},
      ),
    ),
  );
}
