import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login_screen.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _cpf = TextEditingController();
  final _dob = TextEditingController();
  final _phone = TextEditingController();

  bool _isLoading = false;

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {

        // Dados do formulário
        Map<String, String> body = {
          'name': _name.text,
          'email': _email.text,
          'password': _password.text,
          'cpf': _cpf.text,
          'birth': _dob.text,
          'phone': _phone.text,
          'confirmedPassword': _confirmPassword.text
        };

        final String baseUrl = Platform.isIOS
            ? 'http://localhost:5001/users/registration'
            : 'http://10.0.2.2:5001/users/registration';

        // Chamada à API para registro
        var response = await http.post(
          Uri.parse(baseUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        );

        if (response.statusCode == 201) {
          // Registro bem-sucedido
          var user = await _authenticateUser(_email.text, _password.text);

          if (user != null) {
            // Usuário autenticado com sucesso
            var userUid = user.uid;
            var userEmail = user.email;

            // Criando body do request
            Map<String, String?> bodyRequest = {
              'uid': userUid,
              'email': userEmail,
            };

            final String base = Platform.isIOS
                ? 'http://localhost:5001'
                : 'http://10.0.2.2:5001';

            // Chamada à API para adicionar UID
            var responseUid = await http.post(
              Uri.parse('${base}/users/adduid'),
              headers: {"Content-Type": "application/json"},
              body: jsonEncode(bodyRequest),
            );

            if (responseUid.statusCode == 200) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false,
              );
            } else {
              // Tratar erro na adição de UID
              var jsonResponse = jsonDecode(responseUid.body);
              var message = jsonResponse['error'] ?? 'Erro ao adicionar UID. Entre em contato com o suporte!';
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(message),
              ));
            }
          } else {
            // Tratamento se a autenticação falhar
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Falha ao autenticar o usuário após registro.'),
            ));
          }
        } else {
          // Tratar erro na criação do usuário
          var jsonResponse = jsonDecode(response.body);
          var message = jsonResponse['error'] ?? 'Erro, entre em contato com o suporte!';
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(message),
          ));
        }
    }
  }

  Future<User?> _authenticateUser(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao autenticar: $e'),
      ));
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView( // Permite rolar a tela
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Botão de Voltar no canto superior esquerdo
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0), // Aumentado para 40
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Voltar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),

            // Logo e título
            const SizedBox(height: 10),
            Image.asset(
              'assets/images/BlackSemFrase.png',
              height: 150, // Altura do logo
              width: 200,
            ),
            const SizedBox(height: 10),

            // Container roxo com gradiente e formulário
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(125, 5),
                  topRight: Radius.elliptical(300, 250),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.purpleAccent, Colors.purple],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                // Formulário de registro
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      _buildTextField(_name, 'Nome Completo'),
                      const SizedBox(height: 20),
                      _buildTextField(_email, 'Email'),
                      const SizedBox(height: 20),
                      _buildPasswordField(_password, 'Senha'),
                      const SizedBox(height: 20),
                      _buildPasswordField(_confirmPassword, 'Confirmação de Senha'),
                      const SizedBox(height: 20),
                      _buildTextField(_cpf, 'CPF'),
                      const SizedBox(height: 20),
                      _buildTextField(_dob, 'Data de nascimento'),
                      const SizedBox(height: 20),
                      _buildTextField(_phone, 'Telefone'),
                      const SizedBox(height: 30),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                        onPressed: _isLoading ? null : _registerUser,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Criar conta',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função para criar campos de texto
  Widget _buildTextField(TextEditingController controller, String labelText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira $labelText';
        }
        return null;
      },
    );
  }

  // Função para criar campos de senha
  Widget _buildPasswordField(
      TextEditingController controller, String labelText) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira $labelText';
        }
        return null;
      },
    );
  }
}