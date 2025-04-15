// lib/ui/user/view_model/register_view_model.dart
import 'package:flutter/material.dart';
import '../../data/services/user_service.dart';
import '../../domain/models/user.dart';
import '../../data/database_helper.dart';

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

    if (name.isEmpty) {
      error = 'O nome é obrigatório.';
      isLoading = false;
      notifyListeners();
      return;
    }

    if (password != confirmPassword) {
      error = 'As senhas não coincidem.';
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final user = User(
        id: UniqueKey().toString(),
        name: name,
        email: email,
        password: password,
      );

      await service.registerUser(user);

      final dbHelper = DatabaseHelper();
      await dbHelper.printUsers();

    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
    }

    isLoading = false;
    notifyListeners();
  }
}
