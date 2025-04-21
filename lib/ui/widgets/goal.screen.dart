import 'package:cash_control/ui/widgets/shared/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cash_control/domain/models/goal.dart';
import 'package:cash_control/ui/view_model/goal_view_model.dart';
import 'package:cash_control/ui/widgets/goal_registration.screen.dart';
import 'package:cash_control/data/floor/app_database.dart';
import 'package:percent_indicator/percent_indicator.dart';

class GoalScreen extends StatefulWidget {
  final AppDatabase database;

  const GoalScreen({super.key, required this.database});

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
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Metas Financeiras', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<GoalViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFA100FF)));
          }
          if (viewModel.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Erro ao carregar metas: ${viewModel.errorMessage}',
                    style: const TextStyle(color: Colors.redAccent),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    isLoading: viewModel.isLoading,
                    onPressed: () => viewModel.loadGoals(),
                    icon: Icons.refresh,
                    text: 'Tentar Novamente',
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
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    isLoading: viewModel.isLoading,
                    onPressed: () => _navigateToGoalRegistration(context),
                    icon: Icons.add,
                    text: 'Criar Nova Meta',
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: const Color(0xFFA100FF),
            onRefresh: () => viewModel.loadGoals(),
            child: ListView.separated(
              itemCount: viewModel.goals.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final goal = viewModel.goals[index];
                final percentCompleted = goal.progressPercentage / 100;
                final formattedDeadline = _formatDate(goal.deadline);
                final daysRemaining = goal.daysRemaining;

                Color progressColor = const Color(0xFFA100FF);
                if (goal.isCompleted) {
                  progressColor = Colors.green;
                } else if (daysRemaining < 0) {
                  progressColor = Colors.red;
                } else if (daysRemaining < 7) {
                  progressColor = Colors.orange;
                }

                return Card(
                  color: const Color(0xFF1E1E1E),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
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
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            PopupMenuButton<String>(
                              color: const Color(0xFF1E1E1E),
                              iconColor: Colors.white70,
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _navigateToGoalRegistration(context, goal);
                                }
                                if (value == 'delete') {
                                  _showDeleteConfirmation(context, goal);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, color: Colors.white70),
                                      SizedBox(width: 8),
                                      Text('Editar', style: TextStyle(color: Colors.white70)),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.redAccent),
                                      SizedBox(width: 8),
                                      Text('Excluir', style: TextStyle(color: Colors.redAccent)),
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
                            child: Text(goal.description!, style: const TextStyle(color: Colors.white60)),
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
                          backgroundColor: Colors.white10,
                          barRadius: const Radius.circular(10),
                          animation: true,
                          animationDuration: 1000,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('R\$ ${goal.currentValue.toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.white)),
                            Text('R\$ ${goal.targetValue.toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16, color: Colors.white60),
                                const SizedBox(width: 4),
                                Text('Prazo: $formattedDeadline', style: const TextStyle(color: Colors.white60)),
                              ],
                            ),
                            _buildDaysRemainingBadge(daysRemaining),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFA100FF),
        foregroundColor: Colors.white,
        onPressed: () => _navigateToGoalRegistration(context),
        icon: const Icon(Icons.add),
        label: const Text('Nova Meta'),
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

  Future<void> _navigateToGoalRegistration(BuildContext context, [Goal? goal]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoalRegistrationScreen(goal: goal, database: widget.database),
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
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Excluir Meta', style: TextStyle(color: Colors.white)),
        content: Text(
          'Deseja realmente excluir a meta "${goal.name}"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.read<GoalViewModel>().deleteGoal(goal.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meta excluída com sucesso')),
      );
    }
  }
}
