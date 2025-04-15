import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cash_control/domain/models/goal.dart';
import 'package:cash_control/ui/view_model/goal_registration_view_model.dart';

class GoalRegistrationScreen extends StatefulWidget {
  final Goal? goal;

  const GoalRegistrationScreen({Key? key, this.goal}) : super(key: key);

  @override
  State<GoalRegistrationScreen> createState() => _GoalRegistrationScreenState();
}

class _GoalRegistrationScreenState extends State<GoalRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetValueController = TextEditingController();
  final _currentValueController = TextEditingController();

  late final GoalRegistrationViewModel _viewModel;
  DateTime? _selectedDeadline;

  @override
  void initState() {
    super.initState();
    _viewModel = GoalRegistrationViewModel();

    if (widget.goal != null) {
      _viewModel.loadGoal(widget.goal!);
      _nameController.text = widget.goal!.name;
      _descriptionController.text = widget.goal!.description ?? '';
      _targetValueController.text = widget.goal!.targetValue.toString();
      _currentValueController.text = widget.goal!.currentValue.toString();
      _selectedDeadline = widget.goal!.deadline;
    } else {
      _viewModel.reset();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _targetValueController.dispose();
    _currentValueController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.goal == null ? 'Nova Meta' : 'Editar Meta'),
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
                    decoration: const InputDecoration(
                      labelText: 'Nome da Meta',
                      border: OutlineInputBorder(),
                    ),
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
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _targetValueController,
                    decoration: const InputDecoration(
                      labelText: 'Valor Alvo (R\$)',
                      border: OutlineInputBorder(),
                    ),
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
                    decoration: const InputDecoration(
                      labelText: 'Valor Atual (R\$)',
                      border: OutlineInputBorder(),
                    ),
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
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Data limite',
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(
                      text: _selectedDeadline == null
                          ? ''
                          : '${_selectedDeadline!.day.toString().padLeft(2, '0')}/${_selectedDeadline!.month.toString().padLeft(2, '0')}/${_selectedDeadline!.year}',
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDeadline ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 3650)),
                      );
                      if (picked != null) {
                        setState(() => _selectedDeadline = picked);
                      }
                    },
                    validator: (value) {
                      if (_selectedDeadline == null) {
                        return 'Selecione uma data limite';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
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

                        final success = await _viewModel.saveGoal(
                          name: _nameController.text,
                          description: _descriptionController.text,
                          targetValue: target,
                          currentValue: current,
                          deadline: _selectedDeadline!,
                          goalId: widget.goal?.id,
                        );

                        if (success) {
                          if (_viewModel.successMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(_viewModel.successMessage!)),
                            );
                            _viewModel.clearMessages();
                          }
                          Navigator.pop(context, true);
                        } else if (_viewModel.error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(_viewModel.error!)),
                          );
                          _viewModel.clearMessages();
                        }
                      }
                    },
                    child: Text(widget.goal == null ? 'Criar Meta' : 'Salvar Alterações'),
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


