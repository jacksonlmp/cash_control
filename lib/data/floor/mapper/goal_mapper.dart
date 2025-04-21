import 'package:cash_control/domain/models/goal.dart';
import '../entities/goal_entity.dart';

extension GoalMapper on Goal {
  GoalEntity toEntity() => GoalEntity(
    id: id,
    name: name,
    description: description,
    targetValue: targetValue,
    currentValue: currentValue,
    deadline: deadline.toIso8601String(),
  );
}

extension GoalEntityMapper on GoalEntity {
  Goal toModel() => Goal(
    id: id,
    name: name,
    description: description,
    targetValue: targetValue,
    currentValue: currentValue,
    deadline: DateTime.parse(deadline),
  );
}
