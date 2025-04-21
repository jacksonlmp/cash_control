import 'package:cash_control/ui/widgets/welcome.screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../mocks/mocksTest.mocks.dart';
import 'package:mockito/mockito.dart';

void main() {
  late MockNavigatorObserver mockObserver;

  setUp(() {
    mockObserver = MockNavigatorObserver();
  });

  testWidgets('Deve renderizar corretamente e navegar ao clicar no botão', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: const WelcomeScreen(),
      navigatorObservers: [mockObserver],
      routes: {
        '/login': (_) => const Scaffold(body: Text('Tela de Login')),
      },
    ));

    // Verificando elementos na tela inicial
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('O jeito mais fácil de controlar suas'), findsOneWidget);
    expect(find.text('FINANÇAS'), findsOneWidget);
    expect(find.text('Próximo'), findsOneWidget);

    // Clicando no botão
    await tester.tap(find.text('Próximo'));
    await tester.pumpAndSettle();

    // Agora corrigido: validando que ocorreram exatamente 2 pushes (rota inicial + login)
    verify(mockObserver.didPush(any, any)).called(2);

    // Valida que a tela seguinte apareceu corretamente
    expect(find.text('Tela de Login'), findsOneWidget);
  });
  ;
}
