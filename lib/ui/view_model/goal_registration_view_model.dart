import 'package:flutter/foundation.dart';
import 'package:cash_control/data/services/goal_service.dart';
import 'package:cash_control/domain/models/goal.dart';
import 'package:uuid/uuid.dart';

class GoalRegistrationViewModel extends ChangeNotifier {
  final GoalService _goalService;
  final Uuid _uuid;

  GoalRegistrationViewModel(this._goalService, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  String _name = '';
  String _description = '';
  double _targetValue = 0.0;
  double _currentValue = 0.0;
  DateTime _deadline = DateTime.now().add(const Duration(days: 30));
  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  String get name => _name;
  String get description => _description;
  double get targetValue => _targetValue;
  double get currentValue => _currentValue;
  DateTime get deadline => _deadline;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;

  void setName(String value) {
    final trimmed = value.trim();
    if (_name != trimmed) {
      _name = trimmed;
      notifyListeners();
    }
  }

  void setDescription(String value) {
    final trimmed = value.trim();
    if (_description != trimmed) {
      _description = trimmed;
      notifyListeners();
    }
  }

  void setTargetValue(double value) {
    if (_targetValue != value) {
      _targetValue = value;
      notifyListeners();
    }
  }

  void setCurrentValue(double value) {
    if (_currentValue != value) {
      _currentValue = value;
      notifyListeners();
    }
  }

  void setDeadline(DateTime value) {
    if (_deadline != value) {
      _deadline = value;
      notifyListeners();
    }
  }

  bool validate() {
    final isNameValid = _name.isNotEmpty;
    final isTargetValid = _targetValue > 0;
    final isCurrentValid = _currentValue <= _targetValue;
    final isDeadlineValid = _deadline.isAfter(DateTime.now());

    return isNameValid && isTargetValid && isCurrentValid && isDeadlineValid;
  }

  Future<bool> saveGoal({
    required String name,
    String? description,
    required double targetValue,
    required double currentValue,
    required DateTime deadline,
    String? goalId,
  }) async {
    _setLoading(true);
    try {
      final goal = Goal(
        id: goalId ?? _uuid.v4(),
        name: name,
        description: description,
        targetValue: targetValue,
        currentValue: currentValue,
        deadline: deadline,
      );

      if (goalId == null) {
        final id = await _goalService.addGoal(goal);
        if (id > 0) {
          _successMessage = 'Meta criada com sucesso!';
          return true;
        } else {
          _error = 'Erro ao salvar no banco de dados';
          return false;
        }
      } else {
        final updated = await _goalService.updateGoal(goal);
        if (updated > 0) {
          _successMessage = 'Meta atualizada com sucesso!';
          return true;
        } else {
          _error = 'Erro ao atualizar a meta';
          return false;
        }
      }
    } catch (e) {
      _error = 'Erro: ${e.toString()}';
      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  void loadGoal(Goal goal) {
    _name = goal.name;
    _description = goal.description ?? '';
    _targetValue = goal.targetValue;
    _currentValue = goal.currentValue;
    _deadline = goal.deadline;
    notifyListeners();
  }

  void reset() {
    _name = '';
    _description = '';
    _targetValue = 0.0;
    _currentValue = 0.0;
    _deadline = DateTime.now().add(const Duration(days: 30));
    _error = null;
    _successMessage = null;
    notifyListeners();
  }

  void clearMessages() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }
}

