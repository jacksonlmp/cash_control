// lib/ui/dashboard/widgets/dashboard.screen.dart
import 'package:cash_control/data/repositories/category_repository_impl.dart';
import 'package:cash_control/data/repositories/financial_entry_repository_impl.dart';
import 'package:cash_control/data/services/category_service.dart';
import 'package:cash_control/data/services/financial_entry_service.dart';
import 'package:cash_control/domain/enum/financial_entry_type.dart';
import 'package:cash_control/ui/view_model/financial_entry_registration_view_model.dart';
import 'package:cash_control/ui/view_model/financial_entry_view_model.dart';
import 'package:cash_control/ui/widgets/financial_entry_registration.screen.dart';
import 'package:cash_control/ui/widgets/shared/bottom_navigation_bar.dart';
import 'package:cash_control/ui/widgets/shared/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FinancialEntryScreen extends StatelessWidget {
  const FinancialEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return ChangeNotifierProvider(
      create:
          (_) => FinancialEntryViewModel(
            FinancialEntryService(
              FinancialEntryRepositoryImpl(),
              CategoryService(CategoryRepositoryImpl()),
            ),
          ),
      child: Consumer<FinancialEntryViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Despesas',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.black,
              shape: const Border(
                bottom: BorderSide(color: Colors.white, width: 1.5),
              ),
            ),
            body: Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    if (viewModel.errorMessage.isNotEmpty)
                      Text(
                        viewModel.errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    if (viewModel.financialEntries.isEmpty)
                      const Text(
                        'Nenhuma despesa/receita cadastrada',
                        style: TextStyle(color: Colors.white),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: viewModel.financialEntries.length,
                          itemBuilder: (context, index) {
                            final financialEntry =
                                viewModel.financialEntries[index];
                            return Card(
                              color: Colors.grey[900],
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          financialEntry.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFA100FF),
                                          ),
                                          child: Text(
                                            viewModel.getCategoryNameById(
                                              financialEntry.categoryId,
                                            ),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'R\$ ${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(financialEntry.value)}',
                                          style: TextStyle(
                                            color:
                                                financialEntry.type ==
                                                        FinancialEntryType
                                                            .despesa
                                                    ? Colors.red
                                                    : Colors.green,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          '${financialEntry.date.day.toString().padLeft(2, '0')}/'
                                          '${financialEntry.date.month.toString().padLeft(2, '0')}/'
                                          '${financialEntry.date.year}',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Saldo',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Builder(
                                builder: (context) {
                                  final balance = viewModel.getBalance();
                                  final balanceColor =
                                      balance > 0
                                          ? Colors.green
                                          : balance < 0
                                          ? Colors.red
                                          : Colors.white;

                                  return Text(
                                    'R\$ ${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(balance)}',
                                    style: TextStyle(
                                      color: balanceColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: CustomButton(
                              isLoading: viewModel.isLoading,
                              text: 'Cadastrar',
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => ChangeNotifierProvider(
                                          create:
                                              (
                                                _,
                                              ) => FinancialEntryRegistrationViewModel(
                                                FinancialEntryService(
                                                  FinancialEntryRepositoryImpl(),
                                                  CategoryService(
                                                    CategoryRepositoryImpl(),
                                                  ),
                                                ),
                                              ),
                                          child:
                                              const FinancialEntryRegistrationScreen(),
                                        ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: buildBottomNavigationBar(
              viewModel,
              context,
              scaffoldKey,
            ),
          );
        },
      ),
    );
  }
}
