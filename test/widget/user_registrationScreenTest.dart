// test/widgets/user_registration_screen_test.dart
import 'package:cash_control/ui/widgets/user_registration.screen.dart';
import 'package:cash_control/ui/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../mocks/mocksTest.mocks.dart';

void main() {
  late MockNavigatorObserver mockObserver;
  late UserViewModel mockUserViewModel;

  setUp(() {
    mockObserver = MockNavigatorObserver();
    mockUserViewModel = MockUserViewModel();

    // Inicialização padrão dos getters do ViewModel
    when(mockUserViewModel.isLoading).thenReturn(false);
    when(mockUserViewModel.errorMessage).thenReturn('');
    when(mockUserViewModel.isRegistered).thenReturn(false);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      navigatorObservers: [mockObserver],
      routes: {'/login': (_) => const Scaffold(body: Text('Login Screen'))},
      home: ChangeNotifierProvider<UserViewModel>.value(
        value: mockUserViewModel,
        child: const UserRegistrationScreen(),
      ),
    );
  }

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized().renderView.configuration =
    TestViewConfiguration(size: Size(1024, 1600));
  });

  testWidgets('Deve mostrar campos de cadastro e permitir interação',
          (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.text('Cadastro'), findsOneWidget);
        expect(find.byType(TextField), findsNWidgets(4));
        expect(find.text('Cadastrar'), findsOneWidget);
      });

  testWidgets('Deve realizar cadastro ao clicar em Cadastrar', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(find.widgetWithText(TextField, 'Nome'), 'Joao');
    await tester.enterText(
        find.widgetWithText(TextField, 'E-mail'), 'joao@email.com');
    await tester.enterText(
        find.widgetWithText(TextField, 'Senha'), 'Senha@1234');
    await tester.enterText(
        find.widgetWithText(TextField, 'Confirmar Senha'), 'Senha@1234');

    await tester.tap(find.text('Cadastrar'));
    verify(mockUserViewModel.registerUser()).called(1);
  });

  testWidgets('Deve exibir mensagem de sucesso e navegar após cadastro',
          (tester) async {
        when(mockUserViewModel.isRegistered).thenReturn(true);

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump(); // Executa addPostFrameCallback

        expect(find.text('Usuário cadastrado com sucesso!'), findsOneWidget);

        // Simula o delay de 3 segundos
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        verify(mockObserver.didPush(any, any)).called(greaterThan(0));
        expect(find.text('Login Screen'), findsOneWidget);
      });

  testWidgets('Deve exibir mensagem de erro caso ocorra falha no cadastro',
          (tester) async {
        when(mockUserViewModel.errorMessage)
            .thenReturn('Erro ao cadastrar usuário');

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.text('Erro ao cadastrar usuário'), findsOneWidget);
      });
}