class Goal {
  final String id;
  final String name;
  final String? description;
  final double targetValue;
  final double currentValue;
  final DateTime deadline;

  Goal({
    required this.id,
    required this.name,
    this.description,
    required this.targetValue,
    required this.currentValue,
    required this.deadline,
  });

  Goal copyWith({
    String? id,
    String? name,
    String? description,
    double? targetValue,
    double? currentValue,
    DateTime? deadline,
  }) {
    return Goal(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      deadline: deadline ?? this.deadline,
    );
  }



  double get progressPercentage =>
      targetValue > 0 ? (currentValue / targetValue) * 100 : 0;

  bool get isCompleted => currentValue >= targetValue;

  int get daysRemaining =>
      deadline.difference(DateTime.now()).inDays;
}
