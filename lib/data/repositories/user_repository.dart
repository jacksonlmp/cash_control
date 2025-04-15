import 'package:cash_control/domain/models/user.dart';

abstract class UserRepository {
  Future<void> register(User user);
  Future<bool> existsEmail(String email);
  Future<User?> getUserByEmailAndPassword(String email, String password);
  Future<void> logout(); 
  Future<void> forgotPassword(); 
}
