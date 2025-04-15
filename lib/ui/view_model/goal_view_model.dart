import 'package:cash_control/data/services/goal_service.dart';
import 'package:cash_control/domain/models/goal.dart';
import 'package:flutter/material.dart';

class GoalViewModel extends ChangeNotifier {
  final GoalService _goalService;
  GoalViewModel(this._goalService) {
    loadGoals();
  }

  List<Goal> _goals = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Goal> get goals => _goals;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> loadGoals() async {
    _setLoading(true);
    _errorMessage = '';
    try {
      _goals = await _goalService.getGoals();
      _goals.sort((a, b) => a.deadline.compareTo(b.deadline)); // Ordena por prazo
    } catch (e) {
      _errorMessage = 'Erro ao carregar metas: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteGoal(String id) async {
    _setLoading(true);
    _errorMessage = '';
    try {
      await _goalService.deleteGoal(id);
      _goals.removeWhere((goal) => goal.id == id);
    } catch (e) {
      _errorMessage = 'Erro ao deletar meta: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateGoalProgress(String id, double currentValue) async {
    _errorMessage = '';
    try {
      await _goalService.updateCurrentValue(id, currentValue);
      final index = _goals.indexWhere((goal) => goal.id == id);
      if (index != -1) {
        final goal = _goals[index];
        _goals[index] = goal.copyWith(currentValue: currentValue);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Erro ao atualizar progresso da meta: ${e.toString()}';
      notifyListeners();
    }
  }

  double getTotalSaved() {
    return _goals.fold(0.0, (sum, goal) => sum + goal.currentValue);
  }

  double getTotalTarget() {
    return _goals.fold(0.0, (sum, goal) => sum + goal.targetValue);
  }

  double getOverallProgress() {
    final totalTarget = getTotalTarget();
    return totalTarget == 0 ? 0 : (getTotalSaved() / totalTarget);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void reset() {
    _goals = [];
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }
}

