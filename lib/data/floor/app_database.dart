import 'dart:async';
import 'dao/user_dao.dart';
import 'entities/user_entity.dart';
import 'dao/goal_dao.dart';
import 'entities/goal_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:floor/floor.dart';
import 'dao/category_dao.dart';
import 'dao/financial_entry_dao.dart';
import 'entities/category_entity.dart';
import 'entities/financial_entry_entity.dart';
import 'converter/financial_entry_type_converter.dart';
import 'entities/monthly_total_view.dart';

part 'app_database.g.dart';

@TypeConverters([
  FinancialEntryTypeConverter,
])
@Database(
  version: 1,
  entities: [
    CategoryEntity,
    FinancialEntryEntity,
    GoalEntity,
    UserEntity,
  ],
  views: [
    MonthlyTotalView,
  ],
)
abstract class AppDatabase extends FloorDatabase {
  CategoryDao get categoryDao;
  FinancialEntryDao get financialEntryDao;
  GoalDao get goalDao;
  UserDao get userDao;
}
