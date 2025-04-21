import 'package:cash_control/ui/view_model/goal_registration_view_model.dart';
import 'package:cash_control/ui/widgets/goal_registration.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../mocks/mocksTest.mocks.dart';

void main() {
  late MockGoalRegistrationViewModel mockViewModel;
  late MockAppDatabase mockDatabase;

  setUp(() {
    mockViewModel = MockGoalRegistrationViewModel();
    mockDatabase = MockAppDatabase();

    when(mockViewModel.isLoading).thenReturn(false);
    when(mockViewModel.successMessage).thenReturn(null);
    when(mockViewModel.error).thenReturn(null);
    when(mockViewModel.saveGoal(
      name: anyNamed('name'),
      description: anyNamed('description'),
      targetValue: anyNamed('targetValue'),
      currentValue: anyNamed('currentValue'),
      deadline: anyNamed('deadline'),
      goalId: anyNamed('goalId'),
    )).thenAnswer((_) async => false);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: ChangeNotifierProvider<GoalRegistrationViewModel>.value(
        value: mockViewModel,
        child: GoalRegistrationScreen(database: mockDatabase),
      ),
    );
  }

  testWidgets('Deve exibir todos os campos da tela de metas', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Nome da Meta'), findsOneWidget);
    expect(find.text('Descrição'), findsOneWidget);
    expect(find.text('Valor Alvo (R\$)'), findsOneWidget);
    expect(find.text('Valor Atual (R\$)'), findsOneWidget);
    expect(find.text('Data limite'), findsOneWidget);
    expect(find.text('Criar Meta'), findsOneWidget);
  });

  testWidgets('Deve exibir erro se tentar salvar sem preencher os campos obrigatórios', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Criar Meta'));
    await tester.pumpAndSettle();

    expect(find.text('Informe o nome da meta'), findsOneWidget);
    expect(find.text('Informe o valor alvo'), findsOneWidget);
    expect(find.text('Informe o valor atual'), findsOneWidget);
    expect(find.text('Selecione uma data limite'), findsOneWidget);
  });

  testWidgets('Deve mostrar mensagem de erro vinda do ViewModel', (tester) async {
    when(mockViewModel.error).thenReturn('Erro ao salvar');

    await tester.pumpWidget(createWidgetUnderTest());

    ScaffoldMessenger.of(tester.element(find.byType(GoalRegistrationScreen))).showSnackBar(
      const SnackBar(content: Text('Erro ao salvar')),
    );

    await tester.pump();
    expect(find.text('Erro ao salvar'), findsOneWidget);
  });

  testWidgets('Deve mostrar mensagem de sucesso vinda do ViewModel', (tester) async {
    when(mockViewModel.successMessage).thenReturn('Meta salva com sucesso');

    await tester.pumpWidget(createWidgetUnderTest());

    ScaffoldMessenger.of(tester.element(find.byType(GoalRegistrationScreen))).showSnackBar(
      const SnackBar(content: Text('Meta salva com sucesso')),
    );

    await tester.pump();
    expect(find.text('Meta salva com sucesso'), findsOneWidget);
  });
}
