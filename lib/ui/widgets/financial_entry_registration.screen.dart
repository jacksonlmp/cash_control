import 'package:cash_control/data/repositories/category_repository_impl.dart';
import 'package:cash_control/data/repositories/financial_entry_repository_impl.dart';
import 'package:cash_control/data/services/category_service.dart';
import 'package:cash_control/data/services/financial_entry_service.dart';
import 'package:cash_control/domain/enum/financial_entry_type.dart';
import 'package:cash_control/domain/models/category.dart';
import 'package:cash_control/ui/view_model/financial_entry_registration_view_model.dart';
import 'package:cash_control/ui/widgets/shared/app_bar.dart';
import 'package:cash_control/ui/widgets/shared/custom_button.dart';
import 'package:cash_control/ui/widgets/shared/custom_dropdown.dart';
import 'package:cash_control/ui/widgets/shared/bottom_navigation_bar.dart';
import 'package:cash_control/ui/widgets/shared/end_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cash_control/ui/widgets/shared/custom_text_field.dart';
import 'package:cash_control/ui/widgets/shared/custom_form.dart';

class FinancialEntryRegistrationScreen extends StatelessWidget {
  const FinancialEntryRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return ChangeNotifierProvider(
      create: (_) => FinancialEntryRegistrationViewModel(
        FinancialEntryService(
          FinancialEntryRepositoryImpl(),
          CategoryService(CategoryRepositoryImpl()),
        ),
      ),
      child: Consumer<FinancialEntryRegistrationViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: buildAppBar(context, 'Cadastrar Despesa/Receita', '/financial-entry'),
            endDrawer: buildEndDrawer(context),
            body: Container(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: CustomForm(
                  isLoading: viewModel.isLoading,
                  buttonText: 'Cadastrar',
                  onSubmit: () async {
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
                              'Entrada financeira cadastrada com sucesso!',
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
                        label: 'Categoria',
                        items: viewModel.categories,
                        getLabel: (category) => category.name,
                        onChanged: (Category? newCategory) {
                          if (newCategory != null) {
                            viewModel.setCategory(newCategory);
                          }
                        }
                    ),
                    CustomDropdown(
                        label: 'Tipo',
                        items: FinancialEntryType.values,
                        getLabel: (type) => type == FinancialEntryType.despesa ? 'Despesa' : 'Receita',
                        onChanged: viewModel.setType
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
              ),
            ),
            bottomNavigationBar: buildBottomNavigationBar(viewModel, context, scaffoldKey),
          );
        },
      ),
    );
  }
}
