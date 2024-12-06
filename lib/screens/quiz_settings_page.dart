import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class QuizSettingsPage extends StatefulWidget {
  final String operation;

  QuizSettingsPage({required this.operation});

  @override
  _QuizSettingsPageState createState() => _QuizSettingsPageState();
}

class _QuizSettingsPageState extends State<QuizSettingsPage> {
  final TextEditingController _questionsController = TextEditingController();
  final TextEditingController _startValueController = TextEditingController();
  final TextEditingController _endValueController = TextEditingController();

  String? _errorText;
  bool _isFormValid = false;

  // Função para validar as entradas
  void _validateForm() {
    setState(() {
      _errorText = null;  // Limpa o erro

      // Verifica se os campos são válidos
      if (_questionsController.text.isEmpty ||
          double.tryParse(_questionsController.text) == null) {
        _errorText = 'Número de questões inválido';
      } else if (_startValueController.text.isEmpty ||
          double.tryParse(_startValueController.text) == null) {
        _errorText = 'Valor inicial inválido';
      } else if (_endValueController.text.isEmpty ||
          double.tryParse(_endValueController.text) == null) {
        _errorText = 'Valor final inválido';
      } else {
        _isFormValid = true;  // Formulário válido, pode avançar
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Configurações do Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo "Quantas questões?"
            Text('Quantas questões?'),
            TextField(
              controller: _questionsController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (_) => _validateForm(),
            ),

            // Campo "Valor inicial"
            Text('Valor inicial'),
            TextField(
              controller: _startValueController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (_) => _validateForm(),
            ),

            // Campo "Valor final"
            Text('Valor final'),
            TextField(
              controller: _endValueController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (_) => _validateForm(),
            ),

            // Exibe a mensagem de erro se existir
            if (_errorText != null) ...[
              SizedBox(height: 8),
              Text(
                _errorText!,
                style: TextStyle(color: Colors.red),
              ),
            ],

            // Botão "Gerar as perguntas", habilitado somente se o formulário for válido
            ElevatedButton(
              onPressed: _isFormValid
                  ? () {
                // Lógica para gerar as perguntas
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizPage(), // Página do Quiz
                  ),
                );
              }
                  : null,
              child: Text('Gerar as perguntas'),
            ),
          ],
        ),
      ),
    );
  }
}
