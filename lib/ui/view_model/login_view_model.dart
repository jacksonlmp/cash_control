import 'package:flutter/material.dart';
import 'package:cash_control/domain/models/user.dart';
import 'package:cash_control/data/repositories/user_repository.dart';


class LoginViewModel extends ChangeNotifier {
  final UserRepository _userRepository;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginViewModel(this._userRepository);

  String? error;
  bool isLoading = false;

  Future<void> login() async {
    isLoading = true;
    error = null;

    if (_validateFields()) {
      final email = emailController.text.trim();
      final password = passwordController.text;
      final user = await _userRepository.getUserByEmailAndPassword(email, password);

      if (user == null) {
        error = 'E-mail ou senha inválidos.';
      }
      error = null;
      // Navegar para a próxima tela após login bem sucedido

      isLoading = false;
      notifyListeners();
    }
  }

    Future<void> register() async {
    if (_validateFields()) {
      final email = emailController.text;
      final password = passwordController.text;

      if (await _userRepository.existsEmail(email)) {
        error = 'E-mail já cadastrado';
      } else {
        final user = User(id: '', name: '', email: email, password: password, );
        await _userRepository.register(user);
        error = null;
      }

      notifyListeners();
    }
  }

  bool _validateFields() {
    if (emailController.text.isEmpty) {
      error = 'E-mail é obrigatório.';
      notifyListeners();
      return false;
    }
    if (passwordController.text.isEmpty) {
      error = 'Senha é obrigatória.';
      notifyListeners();

      return false;
    }
    return true;
  }
}
