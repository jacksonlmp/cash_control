import 'package:cash_control/domain/enum/financial_entry_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cash_control/data/services/financial_entry_service.dart';
import 'package:cash_control/domain/models/financial_entry.dart';
import 'package:cash_control/domain/models/category.dart';
import 'package:cash_control/data/services/category_service.dart';
import '../mocks/mocksTest.mocks.dart';

void main() {
  late FinancialEntryService financialEntryService;
  late MockFinancialEntryRepository mockFinancialEntryRepository;
  late MockCategoryRepository mockCategoryRepository;

  setUp(() {
    mockFinancialEntryRepository = MockFinancialEntryRepository();
    mockCategoryRepository = MockCategoryRepository();
    final categoryService = CategoryService(mockCategoryRepository);
    financialEntryService = FinancialEntryService(mockFinancialEntryRepository, categoryService);
  });

  final mockFinancialEntry = FinancialEntry(
    id: '1',
    name: 'Compra de supermercado',
    value: 150.0,
    categoryId: '1',
    type: FinancialEntryType.despesa,
    date: DateTime(2025, 5, 10),
  );

  final mockCategory = Category(id: '1', name: 'Alimentação');

  group('FinancialEntryService Tests', () {
    test('Deve registrar ou atualizar uma entrada financeira', () async {
      when(mockFinancialEntryRepository.register(mockFinancialEntry)).thenAnswer((_) async {});

      await financialEntryService.createOrUpdateFinancialEntry(mockFinancialEntry);

      verify(mockFinancialEntryRepository.register(mockFinancialEntry)).called(1);
    });

    test('Deve retornar uma lista de entradas financeiras', () async {
      when(mockFinancialEntryRepository.findAll()).thenAnswer((_) async => [mockFinancialEntry]);

      final result = await financialEntryService.findAllFinancialEntries();

      expect(result.length, 1);
      expect(result.first.name, 'Compra de supermercado');
      verify(mockFinancialEntryRepository.findAll()).called(1);
    });

    test('Deve deletar uma entrada financeira', () async {
      when(mockFinancialEntryRepository.delete('1')).thenAnswer((_) async {});

      await financialEntryService.deleteFinancialEntry('1');

      verify(mockFinancialEntryRepository.delete('1')).called(1);
    });

    test('Deve retornar uma lista de categorias', () async {
      when(mockCategoryRepository.findAll()).thenAnswer((_) async => [mockCategory]);

      final result = await financialEntryService.findAllCategories();

      expect(result.length, 1);
      expect(result.first.name, 'Alimentação');
      verify(mockCategoryRepository.findAll()).called(1);
    });

    test('Deve falhar ao registrar uma entrada financeira se falhar no repositório', () async {
      when(mockFinancialEntryRepository.register(mockFinancialEntry)).thenThrow(Exception('Falha ao salvar a entrada financeira'));

      expect(
            () async => await financialEntryService.createOrUpdateFinancialEntry(mockFinancialEntry),
        throwsA(isA<Exception>()),
      );
    });

    test('Deve falhar ao deletar uma entrada financeira se falhar no repositório', () async {
      when(mockFinancialEntryRepository.delete('1')).thenThrow(Exception('Falha ao deletar a entrada financeira'));

      expect(
            () async => await financialEntryService.deleteFinancialEntry('1'),
        throwsA(isA<Exception>()),
      );
    });
  });
}


