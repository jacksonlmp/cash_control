import 'package:cash_control/domain/models/category.dart';
import 'package:flutter/material.dart';
import 'package:cash_control/data/services/category_service.dart';

class CategoryRegistrationViewModel extends ChangeNotifier {
  final CategoryService _categoryService;
  CategoryRegistrationViewModel(this._categoryService);

  String _name = '';
  String _errorMessage = '';
  bool _isLoading = false;

  String get name => _name;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  Future<void> registerCategory() async {
    if (_name.isEmpty) {
      _errorMessage = 'O nome é obrigatório.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _categoryService.registerCategory(
        Category(
            id: UniqueKey().toString(),
            name: name
        ),
      );
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void onItemTapped(int index) {
    notifyListeners();
  }
}