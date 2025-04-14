import 'package:cash_control/data/database_helper.dart';
import 'package:cash_control/data/services/financial_entry_service.dart';
import 'package:cash_control/domain/enum/financial_entry_type.dart';
import 'package:cash_control/domain/models/financial_entry.dart';
import 'package:flutter/material.dart';

class FinancialEntryRegistrationViewModel extends ChangeNotifier {
  final FinancialEntryService _financialEntryService;
  FinancialEntryRegistrationViewModel(this._financialEntryService);

  String _name = '';
  double _value = 0.0;
  String _categoryId = '';
  FinancialEntryType _type = FinancialEntryType.despesa;
  DateTime _date = DateTime.now();

  String _errorMessage = '';
  bool _isLoading = false;
  int _selectedIndex = 2;

  // Getters
  String get name => _name;
  double get value => _value;
  String get categoryId => _categoryId;
  FinancialEntryType get type => _type;
  DateTime get date => _date;

  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  int get selectedIndex => _selectedIndex;

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setValue(double value) {
    _value = value;
    notifyListeners();
  }

  void setCategoryId(String categoryId) {
    _categoryId = categoryId;
    notifyListeners();
  }

  void setType(FinancialEntryType? type) {
    _type = type!;
    notifyListeners();
  }

  void setDate(DateTime date) {
    _date = date;
    notifyListeners();
  }

  Future<void> registerFinancialEntry() async {
    if (_name.isEmpty || _value <= 0 || _categoryId.isEmpty) {
      _errorMessage = 'Preencha todos os campos obrigatórios.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _financialEntryService.registerFinancialEntry(
        FinancialEntry(
          id: UniqueKey().toString(),
          name: _name,
          value: _value,
          categoryId: _categoryId,
          type: _type,
          date: _date,
        ),
      );
      _errorMessage = '';
      DatabaseHelper().printFinancialEntries();
    } catch (e) {
      _errorMessage = e.toString();
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
