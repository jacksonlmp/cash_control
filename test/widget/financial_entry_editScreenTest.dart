import 'package:cash_control/domain/enum/financial_entry_type.dart';
import 'package:cash_control/domain/models/category.dart';
import 'package:cash_control/domain/models/financial_entry.dart';
import 'package:cash_control/ui/view_model/financial_entry_edit_view_model.dart';
import 'package:cash_control/ui/widgets/financial_entry_edit.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../mocks/mocksTest.mocks.dart';

void main() {
  late MockFinancialEntryEditViewModel mockViewModel;
  late MockAppDatabase mockDatabase;
  late FinancialEntry mockEntry;
  late DateTime fixedDate;

  setUp(() {
    mockViewModel = MockFinancialEntryEditViewModel();
    mockDatabase = MockAppDatabase();
    fixedDate = DateTime(2025, 4, 20);
    mockEntry = FinancialEntry(
      id: '1',
      name: 'Internet',
      value: 100.0,
      categoryId: '1',
      type: FinancialEntryType.despesa,
      date: fixedDate,
    );

    when(mockViewModel.isLoading).thenReturn(false);
    when(mockViewModel.nameController).thenReturn(TextEditingController(text: 'Internet'));
    when(mockViewModel.valueController).thenReturn(TextEditingController(text: '100.00'));
    when(mockViewModel.date).thenReturn(fixedDate);
    when(mockViewModel.type).thenReturn(FinancialEntryType.despesa);
    when(mockViewModel.errorMessage).thenReturn('');
    when(mockViewModel.categories).thenReturn([
      Category(id: '1', name: 'Internet'),
      Category(id: '2', name: 'Transporte'),
    ]);
    when(mockViewModel.category).thenReturn(Category(id: '1', name: 'Internet'));
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: ChangeNotifierProvider<FinancialEntryEditViewModel>.value(
        value: mockViewModel,
        child: FinancialEntryEditScreen(
          financialEntry: mockEntry,
          database: mockDatabase, // ✅ Adicionado aqui
        ),
      ),
    );
  }

  testWidgets('Deve renderizar os campos do formulário e botão de exclusão', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Nome'), findsOneWidget);
    expect(find.text('Valor'), findsOneWidget);
    expect(find.text('Categoria'), findsOneWidget);
    expect(find.text('Tipo'), findsOneWidget);
    expect(find.text('Excluir'), findsOneWidget);

    // Data formatada
    final formattedDate = 'Data: ${fixedDate.day.toString().padLeft(2, '0')}/'
        '${fixedDate.month.toString().padLeft(2, '0')}/${fixedDate.year}';
    expect(find.text(formattedDate), findsOneWidget);
  });
}
