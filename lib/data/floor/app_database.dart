import 'package:floor/floor.dart';
import 'dao/category_dao.dart';
import 'dao/financial_entry_dao.dart';
import 'entities/category_entity.dart';
import 'entities/financial_entry_entity.dart';
import 'converter/financial_entry_type_converter.dart';

part 'app_database.g.dart';

@TypeConverters([
  FinancialEntryTypeConverter,
])
@Database(
  version: 1,
  entities: [
    CategoryEntity,
    FinancialEntryEntity,
  ],
)
abstract class AppDatabase extends FloorDatabase {
  CategoryDao get categoryDao;
  FinancialEntryDao get financialEntryDao;
}
