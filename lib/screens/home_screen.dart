import 'package:flutter/material.dart';
import 'package:invisto_app/services/lesson-service.dart';
import '../services/ranking-service.dart';
import '../services/user-service.dart';
import 'lesson_screen.dart';
import 'investment_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final UserService _userService;
  late final LessonService _lessonService;
  List<dynamic> lessons = [];
  int qtdInvicoin = 0;
  String rankingId = '';
  late final RankingService _rankingService;
  List<Map<String, dynamic>> rankingParticipants = [];
  bool isInRanking = false;

  @override
  void initState() {
    super.initState();
    _userService = UserService();
    _lessonService = LessonService();
    _getCoin();
    _rankingService = RankingService();
    allLessons();
    _getRankingId();

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

  Future<void> _getRankingId() async {
    final ranking = await _userService.fetchUserRanking();
    if (ranking != null) {
      setState(() {
        rankingId = ranking;
      });
      print("Sucesso ao buscar as ranking.");
    } else {
      print("Erro ao buscar as ranking.");
    }
  }

  Future<void> _getRankingDetails(String rankingId) async {
    final participants = await _rankingService.getRanking(rankingId);
    setState(() {
      rankingParticipants = participants;
    });
  }


  void _createRanking() async {
    final success = await _rankingService.createRanking();
    if (success) {
      setState(() {
        isInRanking = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ranking criado com sucesso!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao criar o ranking")),
      );
    }
  }

  void _enterRanking(String rankingId) async {
    final success = await _rankingService.enterRanking(rankingId);
    if (success) {
      setState(() {
        isInRanking = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Você entrou no ranking!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Falha ao entrar no ranking.")),
      );
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
                  Navigator.of(context).pop();
                  showParticipateDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[900],
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
                child: Text(
                  "Participar de ranking",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _createRanking();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[700],
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
                child: Text(
                  "Criar um ranking",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }

  void showParticipateDialog() {
    final TextEditingController codeController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Participar de ranking"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: codeController,
                decoration: InputDecoration(
                  labelText: "Código de convite",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                final rankingId = codeController.text.trim();
                if (rankingId.isNotEmpty) {
                  Navigator.of(context).pop();
                  _enterRanking(rankingId);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Insira um código válido.")),
                  );
                }
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
          onPressed: () => Navigator.pop(context),
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
        color: Colors.purple[700],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Text(
                'Saldo: R\$${qtdInvicoin}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
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
            if (!isInRanking)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: ElevatedButton(
                  onPressed: showJoinRankingDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[900],
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
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
                    ...List.generate(2, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          height: 40,
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LessonScreen(subject: lesson['subject']),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.purple[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              lesson['subject'],
              style: TextStyle(
                fontSize: 16,
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
