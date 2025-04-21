import 'package:cash_control/data/repositories/user_repository.dart';
import 'package:cash_control/domain/models/user.dart';

class UserService {
  final UserRepository _repository;

  UserService(this._repository);

  Future<void> registerUser(User user) async {
    if (!_isValidEmail(user.email)) {
      throw Exception('Email inválido');
    }
    if (!_isValidPassword(user.password)) {
      throw Exception('Senha fraca');
    }

    if (await _repository.existsEmail(user.email)) {
      throw Exception('E-mail já está em uso');
    }

    await _repository.register(user);
  }

  Future<User?> login(String email, String password) async {
    return await _repository.getUserByEmailAndPassword(email, password);
  }

  Future<void> logout() async {
    await _repository.logout();
  }

  Future<void> forgotPassword() async {

    await _repository.forgotPassword();
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );
    return emailRegex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    final passwordRegex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{6,}$'
    );
    return passwordRegex.hasMatch(password);
  }
}