import 'package:cash_control/domain/models/user.dart';
import 'package:cash_control/data/repositories/user_repository.dart';
import '../../utils/validators.dart';
import 'package:uuid/uuid.dart';

class UserService {
  final UserRepository repository;

  UserService(this.repository);

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    if (!Validators.isValidEmail(email)) {
      throw Exception('Email inválido');
    }

    if (!Validators.isStrongPassword(password)) {
      throw Exception('A senha deve conter pelo menos 8 caracteres, 1 maiúscula e 1 número.');
    }

    final emailExists = await repository.existsEmail(email);
    if (emailExists) {
      throw Exception('Este e-mail já está cadastrado.');
    }

    final user = User(
      id: const Uuid().v4(),
      name: name,
      email: email,
      password: password,
    );

    await repository.register(user);
  }
}
