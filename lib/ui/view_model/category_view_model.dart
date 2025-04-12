import 'package:flutter/material.dart';

class CategoryViewModel extends ChangeNotifier {
  int _selectedIndex = 1;
  int get selectedIndex => _selectedIndex;

  void onItemTapped(int index) {
    _selectedIndex = index;
    notifyListeners();

    // Lógica para redirecionar para as novas rotas/telas
    // Exemplo: AppRouter.pushNamed(_routes[index]);
  }
}
