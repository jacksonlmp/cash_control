import 'package:cash_control/data/floor/app_database.dart';
import 'package:cash_control/data/repositories/category_repository_impl.dart';
import 'package:cash_control/data/repositories/financial_entry_repository_impl.dart';
import 'package:cash_control/data/services/category_service.dart';
import 'package:cash_control/data/services/financial_entry_service.dart';
import 'package:cash_control/domain/enum/financial_entry_type.dart';
import 'package:cash_control/ui/view_model/financial_entry_registration_view_model.dart';
import 'package:cash_control/ui/view_model/financial_entry_view_model.dart';
import 'package:cash_control/ui/widgets/financial_entry_registration.screen.dart';
import 'package:cash_control/ui/widgets/shared/app_bar.dart';
import 'package:cash_control/ui/widgets/shared/bottom_navigation_bar.dart';
import 'package:cash_control/ui/widgets/shared/custom_button.dart';
import 'package:cash_control/ui/widgets/shared/end_drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'financial_entry_edit.screen.dart';

class FinancialEntryScreen extends StatelessWidget {
  final AppDatabase database;

  const FinancialEntryScreen({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    final financialEntryService = FinancialEntryService(
      FinancialEntryRepositoryImpl(database),
      CategoryService(CategoryRepositoryImpl(database.categoryDao)),
    );

    return ChangeNotifierProvider(
      create: (_) => FinancialEntryViewModel(financialEntryService),
      child: Consumer<FinancialEntryViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: buildAppBar(context, 'Transações', '/dashboard'),
            body: Container(
              color: Colors.black,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  if (viewModel.errorMessage.isNotEmpty)
                    Text(viewModel.errorMessage, style: const TextStyle(color: Colors.red)),
                  if (viewModel.financialEntries.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text('Nenhuma transação cadastrada', style: TextStyle(color: Colors.white)),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: viewModel.financialEntries.length,
                        itemBuilder: (context, index) {
                          final entry = viewModel.financialEntries[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FinancialEntryEditScreen(financialEntry: entry, database: database),
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.grey[900],
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(entry.name,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          decoration: const BoxDecoration(color: Color(0xFFA100FF)),
                                          child: Text(
                                            viewModel.getCategoryNameById(entry.categoryId),
                                            style: const TextStyle(color: Colors.white, fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'R\$ ${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(entry.value)}',
                                          style: TextStyle(
                                            color: entry.type == FinancialEntryType.despesa
                                                ? Colors.red
                                                : Colors.green,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('dd/MM/yyyy').format(entry.date),
                                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Saldo',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Builder(
                              builder: (context) {
                                final balance = viewModel.getBalance();
                                final color = balance > 0
                                    ? Colors.green
                                    : balance < 0
                                    ? Colors.red
                                    : Colors.white;
                                return Text(
                                  'R\$ ${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(balance)}',
                                  style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
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
                                  builder: (_) => ChangeNotifierProvider(
                                    create: (_) => FinancialEntryRegistrationViewModel(financialEntryService),
                                    child: FinancialEntryRegistrationScreen(database: database),
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
            endDrawer: buildEndDrawer(context, database),
            bottomNavigationBar: buildBottomNavigationBar(viewModel, context, scaffoldKey),
          );
        },
      ),
    );
  }
}
