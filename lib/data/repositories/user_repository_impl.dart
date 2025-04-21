import 'package:cash_control/data/floor/app_database.dart';
import 'package:cash_control/data/floor/mapper/user_mapper.dart';
import 'package:cash_control/data/repositories/user_repository.dart';
import 'package:cash_control/domain/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepositoryImpl implements UserRepository {
  final AppDatabase _db;

  UserRepositoryImpl(this._db);

  @override
  Future<void> register(User user) async {
    await _db.userDao.insertUser(user.toEntity());
  }

  @override
  Future<bool> existsEmail(String email) async {
    final user = await _db.userDao.findUserByEmail(email);
    return user != null;
  }

  @override
  Future<User?> getUserByEmailAndPassword(String email, String password) async {
    final userEntity = await _db.userDao.findUserByEmailAndPassword(email, password);
    if (userEntity != null) {
      final user = userEntity.toModel();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('logged_user_id', user.id);
      return user;
    }
    return null;
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_user_id');
  }

  @override
  Future<void> forgotPassword() async {
    // Implementação futura (ex: enviar email, etc.)
  }
}
