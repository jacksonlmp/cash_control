import 'package:cash_control/ui/widgets/login.screen.dart';
import 'package:cash_control/ui/view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../mocks/mocksTest.mocks.dart';

void main() {
  late MockNavigatorObserver mockObserver;
  late MockLoginViewModel mockLoginViewModel;

  setUp(() {
    mockObserver = MockNavigatorObserver();
    mockLoginViewModel = MockLoginViewModel();

    // Mockando os controladores corretamente
    when(mockLoginViewModel.emailController).thenReturn(TextEditingController());
    when(mockLoginViewModel.passwordController).thenReturn(TextEditingController());

    // Estado padrão
    when(mockLoginViewModel.error).thenReturn(null);
  });

  // Simula uma tela maior para evitar overflow
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized().renderView.configuration =
      TestViewConfiguration(size: Size(1080, 1920));
  });

  Widget createWidgetUnderTest() {
    return MediaQuery(
      data: const MediaQueryData(size: Size(1080, 1920)),
      child: MaterialApp(
        navigatorObservers: [mockObserver],
        routes: {
          '/forgot-password': (_) => const Scaffold(body: Text('Forgot Password')),
          '/register': (_) => const Scaffold(body: Text('Register')),
        },
        home: ChangeNotifierProvider<LoginViewModel>.value(
          value: mockLoginViewModel,
          child: const LoginScreen(),
        ),
      ),
    );
  }

  testWidgets('Deve exibir campos de login e botões corretamente', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Esqueceu sua senha?'), findsOneWidget);
    expect(find.text('Não possui uma conta? Cadastre-se'), findsOneWidget);
  });

  testWidgets('Deve tentar realizar login ao clicar em Entrar', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(find.widgetWithText(TextField, 'E-mail'), 'teste@email.com');
    await tester.enterText(find.widgetWithText(TextField, 'Senha'), 'Senha@123');

    await tester.tap(find.text('Entrar'));
    await tester.pump();

    verify(mockLoginViewModel.login(any)).called(1);
  });

  testWidgets('Deve exibir mensagem de erro caso login falhe', (tester) async {
    when(mockLoginViewModel.error).thenReturn('Erro no login');

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Entrar'));
    await tester.pump();

    expect(find.text('Erro no login'), findsOneWidget);
  });

  testWidgets('Deve navegar para a tela de recuperação de senha', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Esqueceu sua senha?'));
    await tester.pumpAndSettle();

    expect(find.text('Forgot Password'), findsOneWidget);
  });

  testWidgets('Deve navegar para a tela de cadastro', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Não possui uma conta? Cadastre-se'));
    await tester.pumpAndSettle();

    expect(find.text('Register'), findsOneWidget);
  });
}
