import 'package:cash_control/ui/view_model/monthly_financial_chart_view_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Deve renderizar o gráfico com as barras corretas', (WidgetTester tester) async {
    final mockData = {
      '2025-01': {'RECEITA': 1000.0, 'DESPESA': 500.0},
      '2025-02': {'RECEITA': 2000.0, 'DESPESA': 1500.0},
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MonthlyFinancialChart(data: mockData),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verifica se o gráfico está presente
    expect(find.byType(BarChart), findsOneWidget);

    // Verifica se os nomes dos meses aparecem (últimos dois dígitos do mês)
    expect(find.text('01'), findsOneWidget);
    expect(find.text('02'), findsOneWidget);
  });
}
