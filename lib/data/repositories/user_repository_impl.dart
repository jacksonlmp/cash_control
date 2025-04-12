import 'package:cash_control/data/database_helper.dart';
import 'package:cash_control/data/repositories/user_repository.dart';
import 'package:cash_control/domain/models/user.dart';
import 'package:cash_control/data/model/user_model.dart';
import 'package:sqflite/sqflite.dart';

class UserRepositoryImpl implements UserRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<void> register(User user) async {
    final db = await _databaseHelper.database;

    final userModel = UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      password: user.password,
    );

    await db.insert(
      'users',
      userModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<bool> existsEmail(String email) async {
    final db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    return maps.isNotEmpty;
  }
}
