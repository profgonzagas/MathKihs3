import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import '../lib/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Mock para o SoundPlayer
class MockSoundPlayer extends Mock implements SoundPlayer {}

void main() {
  group('MathQuizApp - Testes Expandidos', () {
    late MockSoundPlayer mockSoundPlayer;

    setUp(() {
      mockSoundPlayer = MockSoundPlayer();
    });

    testWidgets('Alterna entre temas claro e escuro', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => QuizState(),
          child: MathQuizApp(),
        ),
      );

      // Verifica tema inicial
      final BuildContext context = tester.element(find.byType(MaterialApp));
      final ThemeData initialTheme = Theme.of(context);
      expect(initialTheme.brightness, Brightness.light);

      // Alterna tema
      await tester.tap(find.byIcon(Icons.dark_mode));
      await tester.pumpAndSettle();

      // Verifica tema atualizado
      final ThemeData updatedTheme = Theme.of(context);
      expect(updatedTheme.brightness, Brightness.dark);
    });

    testWidgets('HomePage - Navegação e Botões', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => QuizState(),
          child: MaterialApp(home: HomePage()),
        ),
      );

      // Verifica se os botões estão na tela
      expect(find.text('Adição'), findsOneWidget);
      expect(find.text('Subtração'), findsOneWidget);

      // Testa navegação para QuizSettingsPage
      await tester.tap(find.text('Adição'));
      await tester.pumpAndSettle();

      expect(find.byType(QuizSettingsPage), findsOneWidget);
    });

    testWidgets('QuizSettingsPage - Geração de perguntas', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => QuizState(),
          child: MaterialApp(
            home: QuizSettingsPage(operation: 'Adição'),
          ),
        ),
      );

      // Preenche campos
      await tester.enterText(find.byType(TextField).at(0), '3'); // Número de questões
      await tester.enterText(find.byType(TextField).at(1), '2'); // Valor inicial
      await tester.enterText(find.byType(TextField).at(2), '5'); // Valor final

      // Gera perguntas
      await tester.tap(find.text('Gerar as perguntas'));
      await tester.pumpAndSettle();

      // Verifica se a QuizPage abriu
      expect(find.byType(QuizPage), findsOneWidget);
    });

    testWidgets('QuizPage - Processamento de Respostas', (WidgetTester tester) async {
      final questions = [
        {
          'question': '2 + 3',
          'options': [5, 4, 6, 7],
          'answer': 5,
        },
      ];

      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => QuizState(),
          child: MaterialApp(
            home: QuizPage(questions: questions),
          ),
        ),
      );

      // Verifica a primeira pergunta
      expect(find.text('2 + 3'), findsOneWidget);

      // Seleciona resposta correta
      await tester.tap(find.text('5'));
      await tester.pump();

      // Testa se SnackBar aparece
      expect(find.text('Acertou!'), findsOneWidget);
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
    testWidgets('HomePage - Abre Instagram', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => QuizState(),
          child: MaterialApp(home: HomePage()),
        ),
      );

      // Verifica o botão do Instagram
      final instagramButton = find.byIcon(FontAwesomeIcons.instagram);
      expect(instagramButton, findsOneWidget);

      // Simula toque
      await tester.tap(instagramButton);
      await tester.pumpAndSettle();

      // Como `_openInstagram` faz uma chamada externa, você pode usar `mockito` para validar chamadas futuras.
    });
  });
}
