import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cash_control/domain/models/goal.dart';
import 'package:cash_control/data/services/goal_service.dart';

import '../mocks/mocksTest.mocks.dart';

void main() {
  late GoalService goalService;
  late MockGoalRepository mockGoalRepository;

  setUp(() {
    mockGoalRepository = MockGoalRepository();
    goalService = GoalServiceTestable(mockGoalRepository);
  });

  final mockGoal = Goal(
    id: '1',
    name: 'Viagem',
    description: 'Viagem para o exterior',
    targetValue: 5000,
    currentValue: 1500,
    deadline: DateTime(2025, 12, 31),
  );

  test('Deve retornar lista de metas', () async {
    when(mockGoalRepository.getGoals()).thenAnswer((_) async => [mockGoal]);

    final result = await goalService.getGoals();

    expect(result.length, 1);
    expect(result.first.name, 'Viagem');
    verify(mockGoalRepository.getGoals()).called(1);
  });

  test('Deve retornar uma meta pelo nome', () async {
    when(mockGoalRepository.getGoal('Viagem')).thenAnswer((_) async => mockGoal);

    final result = await goalService.getGoal('Viagem');

    expect(result.name, 'Viagem');
    verify(mockGoalRepository.getGoal('Viagem')).called(1);
  });

  test('Deve adicionar uma meta', () async {
    when(mockGoalRepository.addGoal(mockGoal)).thenAnswer((_) async => 1);

    final result = await goalService.addGoal(mockGoal);

    expect(result, 1);
    verify(mockGoalRepository.addGoal(mockGoal)).called(1);
  });

  test('Deve atualizar uma meta', () async {
    when(mockGoalRepository.updateGoal(mockGoal)).thenAnswer((_) async => 1);

    final result = await goalService.updateGoal(mockGoal);

    expect(result, 1);
    verify(mockGoalRepository.updateGoal(mockGoal)).called(1);
  });

  test('Deve deletar uma meta pelo ID', () async {
    when(mockGoalRepository.deleteGoal('1')).thenAnswer((_) async => 1);

    final result = await goalService.deleteGoal('1');

    expect(result, 1);
    verify(mockGoalRepository.deleteGoal('1')).called(1);
  });

  test('Deve atualizar o valor atual de uma meta', () async {
    when(mockGoalRepository.updateCurrentValue('1', 2000)).thenAnswer((_) async => 1);

    final result = await goalService.updateCurrentValue('1', 2000);

    expect(result, 1);
    verify(mockGoalRepository.updateCurrentValue('1', 2000)).called(1);
  });
}