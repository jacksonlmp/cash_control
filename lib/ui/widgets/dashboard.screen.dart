// lib/ui/dashboard/widgets/dashboard.screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/dashboard_view_model.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel(),
      child: Consumer<DashboardViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Dashboard',
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
                child: Text(
                  'Conteúdo Dashboard',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: Colors.white),
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
                onTap: viewModel.onItemTapped,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard, color: Colors.white),
                    label: 'Dashboards',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.category, color: Colors.white),
                    label: 'Categorias',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.only(top: 1.0),
                      child: Icon(Icons.add, size: 45, color: Colors.white),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.attach_money, color: Colors.white),
                    label: 'Despesas',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person, color: Colors.white),
                    label: 'Meu perfil',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
