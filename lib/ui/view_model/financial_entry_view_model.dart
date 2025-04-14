import 'package:cash_control/data/services/financial_entry_service.dart';
import 'package:cash_control/domain/models/financial_entry.dart';
import 'package:flutter/material.dart';

class FinancialEntryViewModel extends ChangeNotifier {
  final FinancialEntryService _financialEntryService;
  FinancialEntryViewModel(this._financialEntryService) {
    loadFinancialEntry();
  }

  int _selectedIndex = 3;
  String _errorMessage = '';
  bool _isLoading = false;
  List<FinancialEntry> _financialEntries = [];

  int get selectedIndex => _selectedIndex;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  List<FinancialEntry> get financialEntries => _financialEntries;

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

  void onItemTapped(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
