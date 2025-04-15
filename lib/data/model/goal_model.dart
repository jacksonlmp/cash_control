import 'package:cash_control/domain/models/goal.dart';

class GoalModel extends Goal {
  GoalModel({
  required super.id,
  required super.name,
  required super.description,
  required super.targetValue,
  required super.currentValue,
  required super.deadline,
  });

  factory GoalModel.fromMap(Map<String, dynamic> map) {
    return GoalModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      targetValue: map['targetValue'],
      currentValue: map['currentValue'],
      deadline: DateTime.parse(map['deadline']),
    );
  }

  Map<String, dynamic> toMap() {
    return{
      'id': id,
      'name': name,
      'description': description,
      'targetValue': targetValue,
      'currentValue': currentValue,
      'deadline': deadline.toIso8601String(),
    };
  }
}