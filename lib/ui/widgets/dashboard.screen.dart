import 'package:cash_control/data/services/user_service.dart';
import 'package:cash_control/ui/widgets/shared/bottom_navigation_bar.dart';
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
                      Navigator.pop(context); // Fecha o drawer
                      // Coloque aqui a navegação para a tela de trocar senha
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app, color: Colors.black),
                    title: Text('Logout'),
                    onTap: () {
                      Navigator.pop(context); // Fecha o drawer
                      viewModel.logout(context);
                    },
                  ),
                ],
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
