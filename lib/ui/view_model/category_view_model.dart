import 'package:flutter/material.dart';

class CategoryViewModel extends ChangeNotifier {

  int _selectedIndex = 1;
  String _errorMessage = '';
  bool _isLoading = false;

  int get selectedIndex => _selectedIndex;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  void onItemTapped(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
