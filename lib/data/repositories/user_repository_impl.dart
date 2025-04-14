import 'package:cash_control/data/database_helper.dart';
import 'package:cash_control/data/repositories/user_repository.dart';
import 'package:cash_control/domain/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepositoryImpl implements UserRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<void> register(User user) async {
    final Database db = await _databaseHelper.database;
    await db.insert('users', {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'password': user.password,
    });
  }

  @override
  Future<User?> getUserByEmailAndPassword(String email, String password) async {
    final Database db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (maps.isNotEmpty) {
      final map = maps.first;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('logged_user_id', map['id'].toString());

      return User(
        id: map['id'],
        name: map['name'],
        email: map['email'],
        password: map['password'],
      );
    } else {
      return null;
    }
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

  @override
  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_user_id');
  }
}
