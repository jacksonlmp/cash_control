import 'package:cash_control/domain/models/financial_entry.dart';
import '../entities/financial_entry_entity.dart';

extension FinancialEntryMapper on FinancialEntryEntity {
  FinancialEntry toModel() {
    return FinancialEntry(
      id: id,
      name: name,
      value: value,
      categoryId: categoryId,
      type: type,
      date: DateTime.parse(date),
    );
  }
}

extension FinancialEntryModelMapper on FinancialEntry {
  FinancialEntryEntity toEntity() {
    return FinancialEntryEntity(
      id: id,
      name: name,
      value: value,
      categoryId: categoryId,
      type: type,
      date: date.toIso8601String(),
    );
  }
}
