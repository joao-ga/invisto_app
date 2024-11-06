import 'package:flutter/material.dart';

class InvestmentScreen extends StatelessWidget {
  int qtdInvicoin = 0;

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
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purpleAccent, Colors.purple],
          ),
        ),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            CompanyCard(companyName: 'Apple'),
            CompanyCard(companyName: 'Pfizer'),
            CompanyCard(companyName: 'Microsoft'),
            CompanyCard(companyName: 'Amazon'),
          ],
        ),
      ),
    );
  }
}

class CompanyCard extends StatelessWidget {
  final String companyName;

  const CompanyCard({Key? key, required this.companyName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          companyName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
