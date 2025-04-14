import 'package:cash_control/data/services/user_service.dart';
import 'package:cash_control/navigation/dashboard_navigation.dart';
import 'package:cash_control/ui/widgets/nav_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/dashboard_view_model.dart';
import 'package:cash_control/data/repositories/user_repository_impl.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel(UserService(UserRepositoryImpl())),
      child: Consumer<DashboardViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            key: scaffoldKey,
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
            endDrawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: Colors.black),
                    child: Text(
                      'Meu Perfil',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.lock, color: Colors.black),
                    title: Text('Trocar Senha'),
                    onTap: () {
                      // Adicionar a lógica para trocar senha aqui
                      Navigator.pop(context); // Fecha o drawer
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app, color: Colors.black),
                    title: Text('Logout'),
                    onTap: () {
                      viewModel.logout(context);
                    },
                  ),
                ],
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
                  if (index == 4) {
                    scaffoldKey.currentState?.openEndDrawer();
                  } else {
                    handleDashboardNavigation(index, context);
                  }
                },
                items: buildDashboardNavItems(),
              ),
            ),
          );
        },
      ),
    );
  }
}
