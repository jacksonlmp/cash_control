import 'package:cash_control/domain/models/goal.dart';
import 'package:cash_control/ui/view_model/goal_view_model.dart';
import 'package:cash_control/ui/widgets/goal.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../mocks/mocksTest.mocks.dart';

void main() {
  late MockGoalViewModel mockViewModel;
  late MockAppDatabase mockDatabase;

  setUp(() {
    mockViewModel = MockGoalViewModel();
    mockDatabase = MockAppDatabase();
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: ChangeNotifierProvider<GoalViewModel>.value(
        value: mockViewModel,
        child: GoalScreen(database: mockDatabase),
      ),
    );
  }

  testWidgets('Deve mostrar indicador de carregamento quando isLoading for true', (tester) async {
    when(mockViewModel.isLoading).thenReturn(true);
    when(mockViewModel.errorMessage).thenReturn('');
    when(mockViewModel.goals).thenReturn([]);

    await tester.pumpWidget(createTestWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Deve exibir mensagem de erro e botão de tentar novamente', (tester) async {
    when(mockViewModel.isLoading).thenReturn(false);
    when(mockViewModel.errorMessage).thenReturn('Erro simulado');
    when(mockViewModel.goals).thenReturn([]);

    await tester.pumpWidget(createTestWidget());

    expect(find.textContaining('Erro ao carregar metas'), findsOneWidget);
    expect(find.text('Tentar Novamente'), findsOneWidget);
  });

  testWidgets('Deve mostrar mensagem de nenhuma meta e botão de criar nova meta', (tester) async {
    when(mockViewModel.isLoading).thenReturn(false);
    when(mockViewModel.errorMessage).thenReturn('');
    when(mockViewModel.goals).thenReturn([]);

    await tester.pumpWidget(createTestWidget());

    expect(find.text('Você ainda não possui metas financeiras.'), findsOneWidget);
    expect(find.text('Criar Nova Meta'), findsOneWidget);
  });

  testWidgets('Deve exibir uma meta corretamente', (tester) async {
    final mockGoal = Goal(
      id: '1',
      name: 'Comprar notebook',
      description: 'Para estudos e trabalho',
      targetValue: 5000.0,
      currentValue: 2500.0,
      deadline: DateTime.now().add(const Duration(days: 10)),
    );

    when(mockViewModel.isLoading).thenReturn(false);
    when(mockViewModel.errorMessage).thenReturn('');
    when(mockViewModel.goals).thenReturn([mockGoal]);

    await tester.pumpWidget(createTestWidget());

    expect(find.text('Comprar notebook'), findsOneWidget);
    expect(find.textContaining('R\$ 2500.00'), findsOneWidget);
    expect(find.textContaining('R\$ 5000.00'), findsOneWidget);
    expect(find.textContaining('Faltam'), findsOneWidget);
  });

  testWidgets('Deve chamar onEdit ao clicar no botão editar', (tester) async {
    final mockGoal = Goal(
      id: '1',
      name: 'Meta de Teste',
      targetValue: 1000.0,
      currentValue: 500.0,
      deadline: DateTime.now().add(Duration(days: 5)),
    );

    when(mockViewModel.isLoading).thenReturn(false);
    when(mockViewModel.errorMessage).thenReturn('');
    when(mockViewModel.goals).thenReturn([mockGoal]);

    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(PopupMenuItem<String>, 'Editar'));
    await tester.pumpAndSettle();
  });

  testWidgets('Deve navegar para cadastro ao clicar no botão flutuante', (tester) async {
    when(mockViewModel.isLoading).thenReturn(false);
    when(mockViewModel.errorMessage).thenReturn('');
    when(mockViewModel.goals).thenReturn([]);

    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
  });
}
