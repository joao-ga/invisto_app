import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      setState(() {
        _isLoading = true;
      });

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

      // Chamada à API
      var response = await http.post(
        Uri.parse('http://localhost:5001/users/registration'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        var jsonResponse = jsonDecode(response.body);

        // Se o cadastro for bem-sucedido, autenticar usuário
        _authenticateUser(_email.text, _password.text);
      } else {
        // Tratar erros
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erro ao criar conta.'),
        ));
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _authenticateUser(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao autenticar: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Botão de Voltar no canto superior esquerdo
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
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
              SizedBox(height: 50),
              Text(
                'Invisto',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              Text('Eduque seu bolso'),
              SizedBox(height: 30),

              // Formulário de registro
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(_name, 'Nome Completo'),
                    _buildTextField(_email, 'Email'),
                    _buildPasswordField(_password, 'Senha'),
                    _buildPasswordField(_confirmPassword, 'Confirmação de Senha'),
                    _buildTextField(_cpf, 'CPF'),
                    _buildTextField(_dob, 'Data de nascimento'),
                    _buildTextField(_phone, 'Telefone'),
                    SizedBox(height: 20),
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _registerUser,
                      child: Text('Criar conta'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função para criar campos de texto
  Widget _buildTextField(TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, insira $labelText';
          }
          return null;
        },
      ),
    );
  }

  // Função para criar campos de senha
  Widget _buildPasswordField(
      TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, insira $labelText';
          }
          return null;
        },
      ),
    );
  }
}