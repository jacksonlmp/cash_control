import 'package:cash_control/domain/enum/financial_entry_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks/mocksTest.mocks.dart';  // Importando os mocks
import 'package:cash_control/domain/models/financial_entry.dart';
import 'package:cash_control/data/services/financial_report_service.dart';

void main() {
  late MockFinancialReportRepository mockRepository;
  late FinancialReportService financialReportService;

  setUp(() {

    mockRepository = MockFinancialReportRepository();


    financialReportService = FinancialReportService(mockRepository);
  });

  group('FinancialReportService Tests', () {
    test('Deve retornar relatório mensal agrupado por mês', () async {

      when(mockRepository.getMonthlyReport(2025)).thenAnswer((_) async => {
        '2025-05': [
          FinancialEntry(
            id: '1',
            name: 'Compra de supermercado',
            value: 150.0,
            categoryId: '1',
            type: FinancialEntryType.despesa, // Usando o enum corretamente
            date: DateTime.parse('2025-05-10T00:00:00.000'),
          )
        ]
      });

      final result = await financialReportService.getMonthlyReport(2025);


      expect(result, isNotEmpty);
      expect(result['2025-05'], isNotEmpty);
      expect(result['2025-05']![0].name, 'Compra de supermercado');
    });

    test('Deve retornar relatório mensal vazio quando não houver dados', () async {

      when(mockRepository.getMonthlyReport(2025)).thenAnswer((_) async => {});

      final result = await financialReportService.getMonthlyReport(2025);


      expect(result, isEmpty);
    });

    test('Deve retornar relatorio anual agrupado por ano', () async {

      when(mockRepository.getAnnualReport()).thenAnswer((_) async => {
        2025: [
          FinancialEntry(
            id: '1',
            name: 'Compra de supermercado',
            value: 150.0,
            categoryId: '1',
            type: FinancialEntryType.despesa,
            date: DateTime.parse('2025-05-10T00:00:00.000'),
          )
        ]
      });

      final result = await financialReportService.getAnnualReport();

      expect(result, isNotEmpty);
      expect(result[2025], isNotEmpty);
      expect(result[2025]![0].name, 'Compra de supermercado');
    });


    test('Deve retornar relatório anual vazio quando não houver dados', () async {

      when(mockRepository.getAnnualReport()).thenAnswer((_) async => {});

      final result = await financialReportService.getAnnualReport();


      expect(result, isEmpty);
    });
  });
}
