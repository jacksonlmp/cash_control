import 'package:cash_control/data/services/financial_entry_service.dart';
import 'package:cash_control/domain/enum/financial_entry_type.dart';
import 'package:cash_control/domain/models/category.dart';
import 'package:cash_control/domain/models/financial_entry.dart';
import 'package:flutter/material.dart';

class FinancialEntryViewModel extends ChangeNotifier {
  final FinancialEntryService _financialEntryService;
  FinancialEntryViewModel(this._financialEntryService) {
    loadFinancialEntry();
    loadCategories();
  }

  int _selectedIndex = 3;
  String _errorMessage = '';
  bool _isLoading = false;
  List<FinancialEntry> _financialEntries = [];
  List<Category> _categories = [];

  int get selectedIndex => _selectedIndex;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  List<FinancialEntry> get financialEntries => _financialEntries;
  List<Category> get categories => _categories;

  Future<void> loadFinancialEntry() async {
    _isLoading = true;
    notifyListeners();
    try {
      _financialEntries = await _financialEntryService.findAllFinancialEntries();
    } catch (e) {
      _errorMessage = 'Erro ao carregar despesas/receitas';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();
    try {
      _categories = await _financialEntryService.findAllCategories();
    } catch (e) {
      _errorMessage = 'Erro ao carregar categorias';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String getCategoryNameById(String id) {
    final category = categories.firstWhere(
          (c) => c.id == id,
      orElse: () => Category(id: '', name: 'Desconhecida'),
    );
    return category.name;
  }

  double getBalance() {
    double balance = 0;
    for (var financialEntry in _financialEntries) {
      if (financialEntry.type == FinancialEntryType.receita) {
        balance += financialEntry.value;
      } else {
        balance -= financialEntry.value;
      }
    }
    return balance;
  }

  void onItemTapped(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
