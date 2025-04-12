import 'package:cash_control/data/services/category_service.dart';
import 'package:flutter/material.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryService categoryService;
  CategoryViewModel(this.categoryService);

  int _selectedIndex = 1;
  int get selectedIndex => _selectedIndex;

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
    _selectedIndex = index;
    notifyListeners();

    // Lógica para redirecionar para as novas rotas/telas
    // Exemplo: AppRouter.pushNamed(_routes[index]);
  }
}
