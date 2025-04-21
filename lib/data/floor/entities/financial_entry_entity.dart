import 'package:floor/floor.dart';
import 'package:cash_control/domain/enum/financial_entry_type.dart';

@entity
class FinancialEntryEntity {
  @primaryKey
  final String id;
  final String name;
  final double value;
  @ColumnInfo(name: 'category_id')
  final String categoryId;
  final FinancialEntryType type;
  final String date;

  FinancialEntryEntity({
    required this.id,
    required this.name,
    required this.value,
    required this.categoryId,
    required this.type,
    required this.date,
  });
}
