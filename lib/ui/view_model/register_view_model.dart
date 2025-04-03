import 'package:flutter/material.dart';
import '../../data/services/user_services.dart';

class RegisterViewModel extends ChangeNotifier {
  final UserService service;

  RegisterViewModel(this.service);

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? error;
  bool isLoading = false;

  Future<void> register() async {
    isLoading = true;
    error = null;
    notifyListeners();

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // Validação: nome obrigatório
    if (name.isEmpty) {
      error = 'O nome é obrigatório.';
      isLoading = false;
      notifyListeners();
      return;
    }

    // Validação: senhas são idênticas
    if (password != confirmPassword) {
      error = 'As senhas não coincidem.';
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      await service.registerUser(
        name: name,
        email: email,
        password: password,
      );
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
    }

    isLoading = false;
    notifyListeners();
  }
}
