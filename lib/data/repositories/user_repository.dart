import 'package:cash_control/domain/models/user.dart';

abstract class UserRepository {
  Future<void> register(User user);
  Future<bool> existsEmail(String email);
}
