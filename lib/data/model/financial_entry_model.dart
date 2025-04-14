import 'package:cash_control/domain/enum/financial_entry_type.dart';

import '../../domain/models/financial_entry.dart';

class FinancialEntryModel extends FinancialEntry {
  FinancialEntryModel({
    required super.id,
    required super.name,
    required super.value,
    required super.categoryId,
    required super.type,
    required super.date,
  });

  factory FinancialEntryModel.fromMap(Map<String, dynamic> map) {
    return FinancialEntryModel(
      id: map['id'],
      name: map['name'],
      value: map['value'] is int ? (map['value'] as int).toDouble() : map['value'],
      categoryId: map['category_id'],
      type: FinancialEntryType.values.firstWhere(
            (e) => e.name.toUpperCase() == map['type'],
        orElse: () => FinancialEntryType.despesa,
      ),
      date: DateTime.parse(map['date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'category_id': categoryId,
      'type': type.name.toUpperCase(),
      'date': date.toIso8601String(),
    };
  }
}
