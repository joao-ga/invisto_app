import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _cpfController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Dados do formulário
      Map<String, String> body = {
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'cpf': _cpfController.text,
        'dob': _dobController.text,
        'phone': _phoneController.text,
      };

      // Chamada à API
      var response = await http.post(
        Uri.parse('SUA_API_URL'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        // Se o cadastro for bem-sucedido, autenticar usuário
        _authenticateUser(_emailController.text, _passwordController.text);
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
    var response = await http.post(
      Uri.parse('SUA_API_AUTHENTICATOR_URL'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Sucesso: Redirecionar ou salvar token
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Usuário autenticado com sucesso!'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Falha na autenticação.'),
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
                    _buildTextField(_nameController, 'Nome Completo'),
                    _buildTextField(_emailController, 'Email'),
                    _buildPasswordField(_passwordController, 'Senha'),
                    _buildPasswordField(
                        _confirmPasswordController, 'Confirmação de Senha'),
                    _buildTextField(_cpfController, 'CPF'),
                    _buildTextField(_dobController, 'Data de nascimento'),
                    _buildTextField(_phoneController, 'Telefone'),
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