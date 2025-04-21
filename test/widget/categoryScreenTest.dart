import 'package:cash_control/domain/models/category.dart';
import 'package:cash_control/ui/widgets/category.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks/mocksTest.mocks.dart';

void main() {
  late MockCategoryViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockCategoryViewModel();

    when(mockViewModel.isLoading).thenReturn(false);
    when(mockViewModel.errorMessage).thenReturn('');
    when(mockViewModel.categories).thenReturn([
      Category(id: '1', name: 'Casa'),
      Category(id: '2', name: 'Transporte'),
    ]);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: CategoryScreen(viewModel: mockViewModel), // ← Injecta o mock
    );
  }

  testWidgets('Deve renderizar categorias corretamente', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Casa'), findsOneWidget);
    expect(find.text('Transporte'), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsNWidgets(2));
    expect(find.text('Cadastrar'), findsOneWidget);
  });

  testWidgets('Deve exibir mensagem de erro', (tester) async {
    when(mockViewModel.errorMessage).thenReturn('Erro ao carregar categorias');
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();
    expect(find.text('Erro ao carregar categorias'), findsOneWidget);
  });

  testWidgets('Deve exibir mensagem quando não há categorias', (tester) async {
    when(mockViewModel.categories).thenReturn([]);
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();
    expect(find.text('Nenhuma categoria cadastrada'), findsOneWidget);
  });
}
