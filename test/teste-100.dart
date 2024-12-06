import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mockito/mockito.dart';
import '../lib/main.dart'; // Ajuste conforme o caminho do seu projeto.

class MockUrlLauncher {
  Future<bool> canLaunchUrl(Uri url) async {
    return url.toString() == 'https://www.instagram.com/profgonzagas/';
  }

  Future<void> launchUrl(Uri url, {LaunchMode mode = LaunchMode.externalApplication}) async {
    if (url.toString() != 'https://www.instagram.com/profgonzagas/') {
      throw Exception('URL inválido');
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockUrlLauncher mockLauncher;

  setUp(() {
    mockLauncher = MockUrlLauncher();
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Teste inicial do MathQuizApp e QuizState', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => QuizState(),
        child: MathQuizApp(),
      ),
    );

    // Verificar tema claro
    expect(find.byType(MaterialApp), findsOneWidget);
    final BuildContext context = tester.element(find.byType(MaterialApp));
    expect(Theme.of(context).colorScheme.brightness, equals(Brightness.light));

    // Alternar para modo escuro
    final quizState = context.read<QuizState>();
    quizState.toggleDarkMode();
    await tester.pumpAndSettle();

    expect(Theme.of(context).colorScheme.brightness, equals(Brightness.dark));
  });

  testWidgets('Teste do botão de Instagram e comportamento do URL', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => QuizState(),
        child: MaterialApp(home: HomePage()),
      ),
    );

    // Mock da função canLaunchUrl
    final validUrl = Uri.parse('https://www.instagram.com/profgonzagas/');
    final invalidUrl = Uri.parse('https://invalid.url/');

    // Teste de sucesso
    expect(await mockLauncher.canLaunchUrl(validUrl), isTrue);
    await mockLauncher.launchUrl(validUrl);

    // Teste de falha
    expect(await mockLauncher.canLaunchUrl(invalidUrl), isFalse);
    expect(() => mockLauncher.launchUrl(invalidUrl), throwsException);

    // Simular clique no botão do Instagram
    await tester.tap(find.byIcon(FontAwesomeIcons.instagram));
    await tester.pump();

    // Verificar se o botão existe
    expect(find.byIcon(FontAwesomeIcons.instagram), findsOneWidget);
  });
}
