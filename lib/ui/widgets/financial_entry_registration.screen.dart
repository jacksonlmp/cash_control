// lib/ui/dashboard/widgets/dashboard.screen.dart
import 'package:cash_control/data/repositories/category_repository_impl.dart';
import 'package:cash_control/data/repositories/financial_entry_repository_impl.dart';
import 'package:cash_control/data/services/category_service.dart';
import 'package:cash_control/data/services/financial_entry_service.dart';
import 'package:cash_control/domain/enum/financial_entry_type.dart';
import 'package:cash_control/domain/models/category.dart';
import 'package:cash_control/navigation/dashboard_navigation.dart';
import 'package:cash_control/ui/view_model/financial_entry_registration_view_model.dart';
import 'package:cash_control/ui/widgets/nav_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FinancialEntryRegistrationScreen extends StatelessWidget {
  const FinancialEntryRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FinancialEntryRegistrationViewModel(
        FinancialEntryService(
          FinancialEntryRepositoryImpl(),
          CategoryService(CategoryRepositoryImpl())
        ),
      ),
      child: Consumer<FinancialEntryRegistrationViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: const Text(
                'Cadastrar Despesas/Receitas',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.black,
              shape: const Border(
                bottom: BorderSide(color: Colors.white, width: 1.5),
              ),
            ),
            body: Container(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),

                    // Nome
                    TextField(
                      onChanged: viewModel.setName,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Nome'),
                    ),

                    const SizedBox(height: 16),

                    // Valor
                    TextField(
                      onChanged: (val) {
                        final parsed = double.tryParse(val.replaceAll(',', '.')) ?? 0.0;
                        viewModel.setValue(parsed);
                      },
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Valor'),
                    ),

                    const SizedBox(height: 16),

                    // Categoria (Dropdown)
                    DropdownButtonFormField<Category>(
                      value: viewModel.category,
                      onChanged: (Category? newCategory) {
                        if (newCategory != null) {
                          viewModel.setCategory(newCategory);
                        }
                      },
                      decoration: _inputDecoration('Categoria'),
                      style: const TextStyle(color: Colors.white),
                      dropdownColor: Colors.grey[900],
                      items: viewModel.categories.map((Category category) {
                        return DropdownMenuItem<Category>(
                          value: category,
                          child: Text(
                            category.name, // Exibe o nome da categoria
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    // Tipo
                    // Dropdown de tipo
                    DropdownButtonFormField<FinancialEntryType>(
                      value: viewModel.type,
                      onChanged: viewModel.setType,
                      dropdownColor: Colors.grey[900],
                      decoration: InputDecoration(
                        labelText: 'Tipo',
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFFA100FF)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFFA100FF), width: 2),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      items: FinancialEntryType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(
                            type == FinancialEntryType.despesa ? 'Despesa' : 'Receita',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    // Data
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: viewModel.date,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.dark(),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          viewModel.setDate(picked);
                        }
                      },
                      child: Text(
                        'Data: ${viewModel.date.day.toString().padLeft(2, '0')}/'
                            '${viewModel.date.month.toString().padLeft(2, '0')}/'
                            '${viewModel.date.year}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    if (viewModel.errorMessage.isNotEmpty)
                      Text(
                        viewModel.errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),

                    const SizedBox(height: 16),

                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA100FF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: viewModel.isLoading
                            ? null
                            : () async {
                          await viewModel.registerFinancialEntry();
                          if (viewModel.errorMessage.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.grey[900],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  title: const Text(
                                    'Sucesso',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  content: const Text(
                                    'Lançamento cadastrado com sucesso!',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text(
                                        'OK',
                                        style: TextStyle(color: Color(0xFFA100FF)),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: viewModel.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Cadastrar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.white, width: 1.5),
                ),
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.black,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white,
                onTap: (index) {
                  viewModel.onItemTapped(index);
                  handleDashboardNavigation(index, context);
                },
                currentIndex: viewModel.selectedIndex,
                items: buildDashboardNavItems(),
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFA100FF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFA100FF), width: 2),
      ),
    );
  }
}


