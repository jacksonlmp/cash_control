// lib/data/floor/dao/user_dao.dart
import 'package:floor/floor.dart';
import '../entities/user_entity.dart';

@dao
abstract class UserDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertUser(UserEntity user);

  @Query('SELECT * FROM users WHERE email = :email AND password = :password')
  Future<UserEntity?> findUserByEmailAndPassword(String email, String password);

  @Query('SELECT * FROM users WHERE email = :email')
  Future<UserEntity?> findUserByEmail(String email);

  @Query('DELETE FROM users WHERE id = :id')
  Future<void> deleteUser(String id);
}
