import 'package:cash_control/data/repositories/user_repository.dart';

import '../../domain/models/user.dart';
import '../model/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final List<UserModel> _users = [];

  @override
  Future<void> register(User user) async {
    final userModel = UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      password: user.password,
    );
    _users.add(userModel);
  }

  @override
  Future<bool> existsEmail(String email) async {
    return _users.any((u) => u.email == email);
  }
}
