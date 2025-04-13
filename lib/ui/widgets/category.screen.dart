// lib/ui/dashboard/widgets/dashboard.screen.dart
import 'package:cash_control/data/repositories/category_repository_impl.dart';
import 'package:cash_control/data/services/category_service.dart';
import 'package:cash_control/navigation/dashboard_navigation.dart';
import 'package:cash_control/ui/view_model/category_registration_view_model.dart';
import 'package:cash_control/ui/view_model/category_view_model.dart';
import 'package:cash_control/ui/widgets/category_registration.screen.dart';
import 'package:cash_control/ui/widgets/nav_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoryViewModel(
          CategoryService(CategoryRepositoryImpl())
      ),
      child: Consumer<CategoryViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Categorias',
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
                    if (viewModel.categories.isEmpty)
                      const Text(
                          'Nenhuma categoria cadastrada',
                          style: TextStyle(color: Colors.white)
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: viewModel.categories.length,
                          itemBuilder: (context, index) {
                            final category = viewModel.categories[index];
                            return Card(
                              color: Colors.grey[900],
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: ListTile(
                                title: Text(
                                  category.name,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.white),
                                  onPressed: () async {
                                    final confirm = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Excluir categoria'),
                                        content: const Text('Tem certeza que deseja excluir esta categoria?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            child: const Text('Excluir'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      await viewModel.deleteCategory(category.id);
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ElevatedButton(
                      onPressed: viewModel.isLoading
                          ? null
                          : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeNotifierProvider(
                              create: (_) => CategoryRegistrationViewModel(
                                  CategoryService(CategoryRepositoryImpl())
                              ),
                              child: const CategoryRegistrationScreen(),
                            ),
                          ),
                        );
                      },
                      child: viewModel.isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Cadastrar'),
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
                currentIndex: viewModel.selectedIndex,
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
