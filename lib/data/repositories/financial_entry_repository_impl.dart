import 'package:cash_control/data/database_helper.dart';
import 'package:cash_control/data/model/financial_entry_model.dart';
import 'package:cash_control/data/repositories/financial_entry_repository.dart';
import 'package:sqflite/sqflite.dart';
import '../../domain/models/financial_entry.dart';

class FinancialEntryRepositoryImpl implements FinancialEntryRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<void> register(FinancialEntry financialEntry) async {
    final db = await _databaseHelper.database;

    final financialEntryModel = FinancialEntryModel(
      id: financialEntry.id,
      name: financialEntry.name,
      value: financialEntry.value,
      categoryId: financialEntry.categoryId,
      type: financialEntry.type,
      date: financialEntry.date,
    );

    await db.insert(
      'financial_entry',
      financialEntryModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<FinancialEntry>> findAll() async {
    final db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query('financial_entry');

    return maps.map((map) => FinancialEntryModel.fromMap(map)).toList();
  }

  @override
  Future<void> delete(String id) async {
    final db = await _databaseHelper.database;
    await db.delete('financial_entry', where: 'id = ?', whereArgs: [id]);
  }
}
