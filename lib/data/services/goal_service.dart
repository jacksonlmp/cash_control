import 'package:cash_control/data/repositories/goal_repository.dart';
import 'package:cash_control/domain/models/goal.dart';

class GoalService {
  final GoalRepository _goalRepository;

  GoalService(this._goalRepository);

  Future<List<Goal>> getGoals() => _goalRepository.getGoals();

  Future<Goal> getGoal(String name) => _goalRepository.getGoal(name);

  Future<int> addGoal(Goal goal) => _goalRepository.addGoal(goal);

  Future<int> updateGoal(Goal goal) => _goalRepository.updateGoal(goal);

  Future<void> deleteGoal(String id) => _goalRepository.deleteGoal(id); // ← atualizado

  Future<void> updateCurrentValue(String id, double currentValue) =>
      _goalRepository.updateCurrentValue(id, currentValue); // ← atualizado
}

class GoalServiceTestable extends GoalService {
  GoalServiceTestable(GoalRepository mockRepo) : super(mockRepo);
}
