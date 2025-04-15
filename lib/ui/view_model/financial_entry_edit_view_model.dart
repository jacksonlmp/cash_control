import 'package:cash_control/data/database_helper.dart';
import 'package:cash_control/data/services/financial_entry_service.dart';
import 'package:cash_control/domain/enum/financial_entry_type.dart';
import 'package:cash_control/domain/models/category.dart';
import 'package:cash_control/domain/models/financial_entry.dart';
import 'package:flutter/material.dart';

class FinancialEntryEditViewModel extends ChangeNotifier {
  final FinancialEntryService _financialEntryService;
  late FinancialEntry _financialEntry;

  late TextEditingController nameController;
  late TextEditingController valueController;

  FinancialEntryEditViewModel(this._financialEntryService, FinancialEntry financialEntry) {
    _financialEntry = financialEntry;
    _name = financialEntry.name;
    _value = financialEntry.value;
    _date = financialEntry.date;
    _type = financialEntry.type;
    _category = null;
    nameController = TextEditingController(text: _name);
    valueController = TextEditingController(text: _value.toStringAsFixed(2));
    loadCategories();
  }

  String _name = '';
  double _value = 0.0;
  Category? _category;
  FinancialEntryType _type = FinancialEntryType.despesa;
  DateTime _date = DateTime.now();
  List<Category> _categories = [];

  String _errorMessage = '';
  bool _isLoading = false;
  int _selectedIndex = 2;

  String get name => _name;
  double get value => _value;
  Category? get category => _category;
  FinancialEntryType get type => _type;
  DateTime get date => _date;
  List<Category> get categories => _categories;

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

  void setCategory(Category? category) {
    _category = category;
    notifyListeners();
  }

  void setType(FinancialEntryType? type) {
    if (type != null) {
      _type = type;
      notifyListeners();
    }
  }

  void setDate(DateTime date) {
    _date = date;
    notifyListeners();
  }

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();
    try {
      _categories = await _financialEntryService.findAllCategories();
      _category = _categories.firstWhere(
            (cat) => cat.id == _financialEntry.categoryId,
        orElse: () => getCategoryById(_financialEntry.categoryId)
      );
    } catch (e) {
      _errorMessage = 'Erro ao carregar categorias';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Category getCategoryById(String id) {
    final category = categories.firstWhere(
          (c) => c.id == id,
      orElse: () => Category(id: '', name: 'Desconhecida'),
    );
    return category;
  }

  Future<void> updateFinancialEntry() async {
    if (_name.isEmpty || _value <= 0 || _category == null) {
      _errorMessage = 'Preencha todos os campos obrigatórios.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final updatedEntry = FinancialEntry(
        id: _financialEntry.id,
        name: _name,
        value: _value,
        categoryId: _category!.id,
        type: _type,
        date: _date,
      );

      await _financialEntryService.createOrUpdateFinancialEntry(updatedEntry);
      _errorMessage = '';
      DatabaseHelper().printFinancialEntries();
    } catch (e) {
      _errorMessage = 'Erro ao editar entrada: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void onItemTapped(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    valueController.dispose();
    super.dispose();
  }
}
