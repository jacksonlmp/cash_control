import 'package:cash_control/domain/enum/financial_entry_type.dart';

class FinancialEntry {
  final String id;
  final String name;
  final double value;
  final String categoryId;
  final FinancialEntryType type;
  final DateTime date;

  FinancialEntry({
    required this.id,
    required this.name,
    required this.value,
    required this.categoryId,
    required this.type,
    required this.date,
  });
}