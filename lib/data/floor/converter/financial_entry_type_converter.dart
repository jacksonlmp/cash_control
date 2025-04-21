import 'package:floor/floor.dart';
import 'package:cash_control/domain/enum/financial_entry_type.dart';

class FinancialEntryTypeConverter extends TypeConverter<FinancialEntryType, String> {
  @override
  FinancialEntryType decode(String databaseValue) {
    return FinancialEntryType.values.firstWhere(
          (e) => e.name == databaseValue.toLowerCase(),
      orElse: () => FinancialEntryType.despesa,
    );
  }

  @override
  String encode(FinancialEntryType value) {
    return value.name;
  }
}
