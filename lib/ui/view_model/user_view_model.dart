import 'package:flutter/material.dart';
import 'package:cash_control/data/services/user_service.dart';
import 'package:cash_control/domain/models/user.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _userService;

  UserViewModel(this._userService);

  String _name = '';
  String _email = '';
  String _password = '';
  String _errorMessage = '';
  bool _isLoading = false;

  String get name => _name;
  String get email => _email;
  String get password => _password;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

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

  Future<void> registerUser() async {
    if (_name.isEmpty || _email.isEmpty || _password.isEmpty) {
      _errorMessage = 'Todos os campos são obrigatórios';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final user = User(
        id: UniqueKey().toString(),
        name: _name,
        email: _email,
        password: _password,
      );
      await _userService.registerUser(user);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
