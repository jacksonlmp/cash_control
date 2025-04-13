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
    final vm = Provider.of<CategoryRegistrationViewModel>(context);
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel(),
      child: Consumer<DashboardViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
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
              color: Colors.black,
              child: Center(
                child: Column(
                  children: [
                    TextField(
                      controller: vm.nameController,
                      decoration: const InputDecoration(labelText: 'Nome'),
                    ),
                    const SizedBox(height: 20),
                    if (vm.error != null)
                      Text(vm.error!, style: const TextStyle(color: Colors.red)),
                    ElevatedButton(
                      onPressed: vm.isLoading ? null : vm.register,
                      child: vm.isLoading
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
