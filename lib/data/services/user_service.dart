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
      throw Exception('Senha não atende aos requisitos de segurança');
    }

    if (await _repository.existsEmail(user.email)) {
      throw Exception('E-mail já está em uso');
    }

    await _repository.register(user);
  }

  Future<User?> login(String email, String password) async {
    return await _repository.getUserByEmailAndPassword(email, password);
  }

  bool _isValidEmail(String email) {
    // Implementar validação de e-mail
    return true;
  }

  bool _isValidPassword(String password) {
    // Implementar validação de senha
    return true;
  }
}
