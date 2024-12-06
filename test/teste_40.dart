
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import '../lib/main.dart';

void main() {
  group('MathQuizApp', () {
    testWidgets('Alterna entre os temas claro e escuro', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => QuizState(),
          child: MathQuizApp(),
        ),
      );

      // Confirma que o tema inicial é claro
      final BuildContext context = tester.element(find.byType(MaterialApp));
      final ThemeData initialTheme = Theme.of(context);
      expect(initialTheme.brightness, Brightness.light);

      // Alterna para o tema escuro
      await tester.tap(find.byIcon(Icons.dark_mode));
      await tester.pumpAndSettle();

      // Verifica se o tema mudou para escuro
      final ThemeData updatedTheme = Theme.of(context);
      expect(updatedTheme.brightness, Brightness.dark);
    });

    testWidgets('Botões de navegação na HomePage funcionam corretamente', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => QuizState(),
          child: MaterialApp(home: HomePage()),
        ),
      );

      // Verifica se os botões estão presentes
      expect(find.text('Adição'), findsOneWidget);
      expect(find.text('Subtração'), findsOneWidget);
      expect(find.text('Multiplicação'), findsOneWidget);
      expect(find.text('Divisão'), findsOneWidget);

      // Testa a navegação para a página de configurações de quiz
      await tester.tap(find.text('Adição'));
      await tester.pumpAndSettle();

      // Verifica se a página de configurações de quiz foi aberta
      expect(find.byType(QuizSettingsPage), findsOneWidget);
    });

    testWidgets('Gera perguntas corretamente na QuizSettingsPage', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => QuizState(),
          child: MaterialApp(
            home: QuizSettingsPage(operation: 'Adição'),
          ),
        ),
      );

      // Preenche os campos do formulário
      await tester.enterText(find.byType(TextField).at(0), '5');
      await tester.enterText(find.byType(TextField).at(1), '1');
      await tester.enterText(find.byType(TextField).at(2), '10');

      // Clica no botão para gerar perguntas
      await tester.tap(find.text('Gerar as perguntas'));
      await tester.pumpAndSettle();

      // Verifica se a página de perguntas foi aberta
      expect(find.byType(QuizPage), findsOneWidget);
    });
  });
}
