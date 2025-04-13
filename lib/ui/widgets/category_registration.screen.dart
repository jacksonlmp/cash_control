// lib/ui/dashboard/widgets/dashboard.screen.dart
import 'package:cash_control/navigation/dashboard_navigation.dart';
import 'package:cash_control/ui/view_model/category_registration_view_model.dart';
import 'package:cash_control/ui/widgets/nav_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/dashboard_view_model.dart';

class CategoryRegistrationScreen extends StatelessWidget {
  const CategoryRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel(),
      child: Consumer<CategoryRegistrationViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: const Text(
                'Cadastrar Categoria',
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
                    TextField(
                      onChanged: viewModel.setName,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Nome',
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
                          await viewModel.registerCategory();
                          if (viewModel.errorMessage.isEmpty) {
                            // Sucesso
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
                                    'Categoria cadastrada com sucesso!',
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
                items: buildDashboardNavItems()
              ),
            ),
          );
        },
      ),
    );
  }
}
