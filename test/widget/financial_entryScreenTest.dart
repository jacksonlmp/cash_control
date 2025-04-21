import 'package:cash_control/domain/enum/financial_entry_type.dart';
import 'package:cash_control/domain/models/category.dart';
import 'package:cash_control/domain/models/financial_entry.dart';
import 'package:cash_control/ui/view_model/financial_entry_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocksTest.mocks.dart';

void main() {
  late MockFinancialEntryService mockService;
  late FinancialEntryViewModel viewModel;

  final mockEntries = [
    FinancialEntry(id: '1', name: 'Salário', value: 3000, type: FinancialEntryType.receita, date: DateTime(2025, 4, 1), categoryId: '1'),
    FinancialEntry(id: '2', name: 'Aluguel', value: 1200, type: FinancialEntryType.despesa, date: DateTime(2025, 4, 5), categoryId: '2'),
    FinancialEntry(id: '3', name: 'Internet', value: 100, type: FinancialEntryType.despesa, date: DateTime(2025, 4, 10), categoryId: '1'),
  ];

  final mockCategories = [
    Category(id: '1', name: 'Casa'),
    Category(id: '2', name: 'Moradia'),
  ];

  setUp(() {
    mockService = MockFinancialEntryService();
    viewModel = FinancialEntryViewModel(mockService);
  });

  test('Deve carregar as transações financeiras corretamente', () async {
    when(mockService.findAllFinancialEntries()).thenAnswer((_) async => mockEntries);
    await viewModel.loadFinancialEntry();

    expect(viewModel.financialEntries.length, 3);
    expect(viewModel.financialEntries[0].name, 'Salário');
    expect(viewModel.errorMessage, '');
  });

  test('Deve calcular corretamente o saldo', () {
    viewModel = FinancialEntryViewModel(mockService);
    viewModel.loadCategories(); // evita erro de categoria ao testar saldo

    viewModel
      ..loadFinancialEntry()
      ..loadCategories();

    // Injetando diretamente os dados simulados
    viewModel.financialEntries.addAll(mockEntries);

    final balance = viewModel.getBalance();
    expect(balance, 1700.0); // 3000 - 1200 - 100
  });

  test('Deve carregar categorias corretamente', () async {
    when(mockService.findAllCategories()).thenAnswer((_) async => mockCategories);
    await viewModel.loadCategories();

    expect(viewModel.categories.length, 2);
    expect(viewModel.categories[1].name, 'Moradia');
  });

  test('Deve retornar nome da categoria pelo ID', () async {
    viewModel = FinancialEntryViewModel(mockService);
    viewModel.categories.addAll(mockCategories);

    final name = viewModel.getCategoryNameById('1');
    expect(name, 'Casa');

    final unknown = viewModel.getCategoryNameById('999');
    expect(unknown, 'Desconhecida');
  });
}
