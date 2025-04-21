import 'package:cash_control/domain/models/category.dart';
import 'package:cash_control/ui/view_model/financial_entry_registration_view_model.dart';
import 'package:cash_control/ui/widgets/financial_entry_registration.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../mocks/mocksTest.mocks.dart';

void main() {
  late MockFinancialEntryRegistrationViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockFinancialEntryRegistrationViewModel();

    when(mockViewModel.isLoading).thenReturn(false);
    when(mockViewModel.date).thenReturn(DateTime(2025, 4, 20));
    when(mockViewModel.errorMessage).thenReturn('');
    when(mockViewModel.categories).thenReturn([
      Category(id: '1', name: 'Alimentação'),
      Category(id: '2', name: 'Transporte'),
    ]);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: ChangeNotifierProvider<FinancialEntryRegistrationViewModel>.value(
        value: mockViewModel,
        child: const FinancialEntryRegistrationScreen(),
      ),
    );
  }

  testWidgets('Deve renderizar todos os campos do formulário', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Nome'), findsOneWidget);
    expect(find.text('Valor'), findsOneWidget);
    expect(find.text('Categoria'), findsOneWidget);
    expect(find.text('Tipo'), findsOneWidget);
  });

  testWidgets('Deve preencher campos e acionar métodos corretamente', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final nameField = find.byType(TextFormField).at(0);
    final valueField = find.byType(TextFormField).at(1);

    await tester.enterText(nameField, 'Salário');
    await tester.enterText(valueField, '1200');

    expect(find.widgetWithText(TextFormField, 'Salário'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, '1200'), findsOneWidget);
  });
}
