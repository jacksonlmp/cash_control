import 'package:floor/floor.dart';

@Entity(tableName: 'goals')
class GoalEntity {
  @primaryKey
  final String id;

  final String name;
  final String? description;
  final double targetValue;
  final double currentValue;
  final String deadline;

  GoalEntity({
    required this.id,
    required this.name,
    this.description,
    required this.targetValue,
    required this.currentValue,
    required this.deadline,
  });
}
