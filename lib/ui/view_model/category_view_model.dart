import 'package:flutter/material.dart';

class CategoryViewModel extends ChangeNotifier {

  int _selectedIndex = 1;
  int get selectedIndex => _selectedIndex;

  String? error;
  bool isLoading = false;

  void onItemTapped(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
