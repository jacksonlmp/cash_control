import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cash_control/domain/models/goal.dart';
import 'package:cash_control/ui/view_model/goal_registration_view_model.dart';
import 'package:cash_control/ui/widgets/shared/custom_button.dart';
import 'package:cash_control/data/services/goal_service.dart';
import 'package:cash_control/data/repositories/goal_repository_impl.dart';
import 'package:cash_control/data/floor/app_database.dart';

class GoalRegistrationScreen extends StatefulWidget {
  final Goal? goal;
  final AppDatabase database;

  const GoalRegistrationScreen({super.key, this.goal, required this.database});

  @override
  State<GoalRegistrationScreen> createState() => _GoalRegistrationScreenState();
}

class _GoalRegistrationScreenState extends State<GoalRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetValueController = TextEditingController();
  final _currentValueController = TextEditingController();
  final _deadlineController = TextEditingController();

  DateTime? _selectedDeadline;

  @override
  void initState() {
    super.initState();
    final goal = widget.goal;

    if (goal != null) {
      _nameController.text = goal.name;
      _descriptionController.text = goal.description ?? '';
      _targetValueController.text = goal.targetValue.toString();
      _currentValueController.text = goal.currentValue.toString();
      _selectedDeadline = goal.deadline;
      _deadlineController.text = _formatDate(goal.deadline);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _targetValueController.dispose();
    _currentValueController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.purpleAccent),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.purpleAccent, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = GoalRegistrationViewModel(
          GoalService(
            GoalRepositoryImpl(widget.database),
          ),
        );
        if (widget.goal != null) {
          viewModel.loadGoal(widget.goal!);
        } else {
          viewModel.reset();
        }
        return viewModel;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E1E1E),
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            widget.goal == null ? 'Nova Meta' : 'Editar Meta',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: Consumer<GoalRegistrationViewModel>(
          builder: (context, viewModel, child) {
            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('Nome da Meta'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o nome da meta';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('Descrição'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _targetValueController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('Valor Alvo (R\$)'),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o valor alvo';
                      }
                      final parsed = double.tryParse(value);
                      if (parsed == null || parsed <= 0) {
                        return 'Digite um valor válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _currentValueController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('Valor Atual (R\$)'),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o valor atual';
                      }
                      final parsed = double.tryParse(value);
                      if (parsed == null || parsed < 0) {
                        return 'Digite um valor válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _deadlineController,
                    readOnly: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('Data limite').copyWith(
                      suffixIcon: const Icon(Icons.calendar_today, color: Colors.purpleAccent),
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDeadline ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 3650)),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: Colors.purpleAccent,
                                onPrimary: Colors.white,
                                surface: Color(0xFF1E1E1E),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedDeadline = picked;
                          _deadlineController.text = _formatDate(picked);
                        });
                      }
                    },
                    validator: (_) {
                      if (_selectedDeadline == null) {
                        return 'Selecione uma data limite';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 50,
                    child: CustomButton(
                      text: widget.goal == null ? 'Criar Meta' : 'Salvar Alterações',
                      isLoading: viewModel.isLoading,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final target = double.parse(_targetValueController.text);
                          final current = double.parse(_currentValueController.text);

                          if (current > target) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('O valor atual não pode ser maior que o valor alvo'),
                              ),
                            );
                            return;
                          }

                          final success = await viewModel.saveGoal(
                            name: _nameController.text,
                            description: _descriptionController.text,
                            targetValue: target,
                            currentValue: current,
                            deadline: _selectedDeadline!,
                            goalId: widget.goal?.id,
                          );

                          if (success) {
                            if (viewModel.successMessage != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(viewModel.successMessage!)),
                              );
                              viewModel.clearMessages();
                            }
                            Navigator.pop(context, true);
                          } else if (viewModel.error != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(viewModel.error!)),
                            );
                            viewModel.clearMessages();
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
