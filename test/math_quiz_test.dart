import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/main.dart'; // Altere o caminho se necessário
import 'package:provider/provider.dart';

void main() {
  group('QuizSettingsPage', () {
    testWidgets('Testa se o formulário coleta e valida as entradas corretamente', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => QuizState(),
          child: MaterialApp(
            home: QuizSettingsPage(operation: 'Adição'),
          ),
        ),
      );

      // Verifica se os textos dos campos de entrada estão presentes
      expect(find.text('Quantas questões?'), findsOneWidget);
      expect(find.text('Valor inicial'), findsOneWidget);
      expect(find.text('Valor final'), findsOneWidget);

      // Preenche os campos com valores válidos
      await tester.enterText(find.byType(TextField).at(0), '10');
      await tester.enterText(find.byType(TextField).at(1), '1');
      await tester.enterText(find.byType(TextField).at(2), '20');

      // Verifica se os valores foram inseridos nos campos
      expect(find.text('10'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('20'), findsOneWidget);

      // Clica no botão "Gerar as perguntas"
      await tester.tap(find.text('Gerar as perguntas'));
      await tester.pumpAndSettle();  // Espera a UI ser atualizada

      // Verifica se a tela de quiz foi carregada
      expect(find.byType(QuizPage), findsOneWidget);
    });

    testWidgets('Testa entradas inválidas no formulário', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => QuizState(),
          child: MaterialApp(
            home: QuizSettingsPage(operation: 'Subtração'),
          ),
        ),
      );

      // Preenche os campos com entradas inválidas
      await tester.enterText(find.byType(TextField).at(0), '');  // Campo vazio
      await tester.enterText(find.byType(TextField).at(1), 'ab');  // Texto não numérico
      await tester.enterText(find.byType(TextField).at(2), 'abc');  // Texto não numérico

      // Verifica se as mensagens de erro são exibidas
      expect(find.text('Número de questões inválido'), findsOneWidget);
      expect(find.text('Valor inicial inválido'), findsOneWidget);
      expect(find.text('Valor final inválido'), findsOneWidget);

      // Verifica se o botão "Gerar as perguntas" está desabilitado
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect((tester.widget<ElevatedButton>(find.byType(ElevatedButton))).onPressed, isNull);

      // Verifica que a página de quiz não foi carregada
      await tester.tap(find.text('Gerar as perguntas'));
      await tester.pumpAndSettle();  // Espera a UI ser atualizada
      expect(find.byType(QuizPage), findsNothing);
    });
  });
}
