import 'package:cash_control/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:cash_control/domain/models/user.dart';
import 'package:uuid/uuid.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _userRepository;

  String _name = '';
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isRegistered = false;

  UserViewModel(this._userRepository);

  String get name => _name;
  String get email => _email;
  String get password => _password;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isRegistered => _isRegistered;

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void setIsRegistered(bool isRegistered) {
    _isRegistered = isRegistered;
    notifyListeners();
  }

  Future<void> registerUser() async {
    _isLoading = true;
    _errorMessage = '';
    _isRegistered = false;
    notifyListeners();

    if (_name.isEmpty || _email.isEmpty || _password.isEmpty) {
      _errorMessage = 'Preencha todos os campos';
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      if (await _userRepository.existsEmail(_email)) {
        _errorMessage = 'E-mail já cadastrado';
      } else {
        final String id = const Uuid().v4();
        final user = User(
          id: id,
          name: _name,
          email: _email,
          password: _password,
        );
        await _userRepository.register(user);
        _isRegistered = true;
      }
    } catch (e) {
      _errorMessage = 'Erro ao cadastrar usuário';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
