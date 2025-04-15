import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cash_control/domain/models/goal.dart';
import 'package:cash_control/ui/view_model/goal_view_model.dart';
import 'package:cash_control/ui/widgets/goal_registration.screen.dart';
import 'package:percent_indicator/percent_indicator.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<GoalViewModel>().loadGoals());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Metas Financeiras'),
      ),
      body: Consumer<GoalViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Erro ao carregar metas: ${viewModel.errorMessage}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => viewModel.loadGoals(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          if (viewModel.goals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Você ainda não possui metas financeiras.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _navigateToGoalRegistration(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Criar Nova Meta'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => viewModel.loadGoals(),
            child: ListView.separated(
              itemCount: viewModel.goals.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final goal = viewModel.goals[index];
                return GoalCard(
                  goal: goal,
                  onEdit: () => _navigateToGoalRegistration(context, goal),
                  onDelete: () => _showDeleteConfirmation(context, goal),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToGoalRegistration(context),
        icon: const Icon(Icons.add),
        label: const Text('Nova Meta'),
      ),
    );
  }

  Future<void> _navigateToGoalRegistration(BuildContext context, [Goal? goal]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoalRegistrationScreen(goal: goal),
      ),
    );

    if (result == true && mounted) {
      context.read<GoalViewModel>().loadGoals();
    }
  }

  Future<void> _showDeleteConfirmation(BuildContext context, Goal goal) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Meta'),
        content: Text('Deseja realmente excluir a meta "${goal.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.read<GoalViewModel>().deleteGoal(goal.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meta excluída com sucesso')),
      );
    }
  }
}

class GoalCard extends StatelessWidget {
  final Goal goal;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const GoalCard({
    Key? key,
    required this.goal,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentCompleted = goal.progressPercentage / 100;
    final formattedDeadline = _formatDate(goal.deadline);
    final daysRemaining = goal.daysRemaining;

    Color progressColor = Colors.blue;
    if (goal.isCompleted) {
      progressColor = Colors.green;
    } else if (daysRemaining < 0) {
      progressColor = Colors.red;
    } else if (daysRemaining < 7) {
      progressColor = Colors.orange;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    goal.name,
                    style: theme.textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') onEdit();
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Editar'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Excluir', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (goal.description != null && goal.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(goal.description!, style: theme.textTheme.bodyMedium),
              ),
            const SizedBox(height: 16),
            LinearPercentIndicator(
              lineHeight: 20.0,
              percent: percentCompleted > 1 ? 1 : percentCompleted,
              center: Text(
                '${goal.progressPercentage.toStringAsFixed(0)}%',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              progressColor: progressColor,
              backgroundColor: Colors.grey[300],
              barRadius: const Radius.circular(10),
              animation: true,
              animationDuration: 1000,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('R\$ ${goal.currentValue.toStringAsFixed(2)}', style: theme.textTheme.bodyLarge),
                Text(
                  'R\$ ${goal.targetValue.toStringAsFixed(2)}',
                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 4),
                    Text('Prazo: $formattedDeadline'),
                  ],
                ),
                _buildDaysRemainingBadge(daysRemaining),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaysRemainingBadge(int days) {
    late final Color backgroundColor;
    late final String text;

    if (days < 0) {
      backgroundColor = Colors.red;
      text = 'Vencido há ${-days} dias';
    } else if (days == 0) {
      backgroundColor = Colors.orange;
      text = 'Vence hoje';
    } else if (days < 7) {
      backgroundColor = Colors.orange;
      text = 'Faltam $days dias';
    } else {
      backgroundColor = Colors.green;
      text = 'Faltam $days dias';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
