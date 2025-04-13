import 'package:flutter/material.dart';
import 'package:cash_control/data/services/category_service.dart';

class CategoryRegistrationViewModel extends ChangeNotifier {
  final CategoryService categoryService;
  CategoryRegistrationViewModel(this.categoryService);

  final nameController = TextEditingController();

  String? error;
  bool isLoading = false;

  Future<void> register() async {
    isLoading = true;
    error = null;
    notifyListeners();

    final name = nameController.text.trim();

    if (name.isEmpty) {
      error = 'O nome é obrigatório.';
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      await categoryService.registerCategory(
        name: name,
      );
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
    }

    isLoading = false;
    notifyListeners();
  }

  void onItemTapped(int index) {
    notifyListeners();
  }
}