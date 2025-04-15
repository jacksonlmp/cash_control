import 'package:cash_control/data/repositories/category_repository_impl.dart';
import 'package:cash_control/data/repositories/financial_entry_repository_impl.dart';
import 'package:cash_control/data/services/category_service.dart';
import 'package:cash_control/data/services/financial_entry_service.dart';
import 'package:cash_control/domain/enum/financial_entry_type.dart';
import 'package:cash_control/domain/models/category.dart';
import 'package:cash_control/domain/models/financial_entry.dart';
import 'package:cash_control/ui/view_model/financial_entry_edit_view_model.dart';
import 'package:cash_control/ui/widgets/shared/custom_button.dart';
import 'package:cash_control/ui/widgets/shared/custom_dropdown.dart';
import 'package:cash_control/ui/widgets/shared/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cash_control/ui/widgets/shared/custom_text_field.dart';
import 'package:cash_control/ui/widgets/shared/custom_form.dart';

class FinancialEntryEditScreen extends StatelessWidget {
  final FinancialEntry financialEntry;

  const FinancialEntryEditScreen({super.key, required this.financialEntry});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return ChangeNotifierProvider(
      create: (_) => FinancialEntryEditViewModel(
        FinancialEntryService(
          FinancialEntryRepositoryImpl(),
          CategoryService(CategoryRepositoryImpl()),
        ),
        financialEntry
      ),
      child: Consumer<FinancialEntryEditViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: const Text(
                'Editar Despesa/Receita',
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
                    CustomForm(
                      isLoading: viewModel.isLoading,
                      buttonText: 'Editar',
                      onSubmit: () async {
                        await viewModel.updateFinancialEntry();
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
                                  'Entrada financeira editada com sucesso!',
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
                                      Navigator.pushReplacementNamed(context, '/financial-entry');
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      formFields: [
                        CustomTextField(
                          label: 'Nome',
                          controller: viewModel.nameController,
                          onChanged: (val) {
                            viewModel.setName(val);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira um nome';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: 'Valor',
                          controller: viewModel.valueController,
                          onChanged: (val) {
                            final parsed = double.tryParse(val.replaceAll(',', '.')) ?? 0.0;
                            viewModel.setValue(parsed);
                          },
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira um valor';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomDropdown(
                            selectedValue: viewModel.type,
                            label: 'Tipo',
                            items: FinancialEntryType.values,
                            getLabel: (type) => type == FinancialEntryType.despesa ? 'Despesa' : 'Receita',
                            onChanged: viewModel.setType
                        ),
                        CustomDropdown(
                            selectedValue: viewModel.category,
                            label: 'Categoria',
                            items: viewModel.categories,
                            getLabel: (category) => category.name,
                            onChanged: (Category? newCategory) {
                              if (newCategory != null) {
                                viewModel.setCategory(newCategory);
                              }
                            }
                        ),
                        CustomButton(
                          isLoading: viewModel.isLoading,
                          text: 'Data: ${viewModel.date.day.toString().padLeft(2, '0')}/'
                              '${viewModel.date.month.toString().padLeft(2, '0')}/'
                              '${viewModel.date.year}',
                          backgroundColor: Colors.grey[900],
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
                        ),
                        if (viewModel.errorMessage.isNotEmpty)
                          Text(
                            viewModel.errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                        isLoading: viewModel.isLoading,
                        text: 'Excluir',
                        backgroundColor: Colors.black,
                        hasBorder: true,
                        onPressed: () async {
                          final confirm = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: Colors.grey[900],
                              title: const Text(
                                'Excluir despesa/receita',
                                style: TextStyle(color: Colors.white),
                              ),
                              content: const Text(
                                'Tem certeza que deseja excluir?',
                                style: TextStyle(color: Colors.white),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text(
                                    'Cancelar',
                                    style: TextStyle(color: Color(0xFFA100FF)),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text(
                                    'Excluir',
                                    style: TextStyle(color: Color(0xFFA100FF)),
                                  ),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await viewModel.deleteFinancialEntry(financialEntry.id);
                            Navigator.pushNamed(context, '/financial-entry');
                          }
                        },
                    )
                  ]
                ),
              ),
            ),
            bottomNavigationBar: buildBottomNavigationBar(viewModel, context, scaffoldKey)
          );
        },
      ),
    );
  }
}
