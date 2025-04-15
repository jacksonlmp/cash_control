import 'package:cash_control/data/services/user_service.dart';
import 'package:cash_control/ui/widgets/shared/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/dashboard_view_model.dart';
import 'package:cash_control/data/repositories/user_repository_impl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>(); // Agora é membro da classe

  @override
  Widget build(BuildContext context) {
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
                  const DrawerHeader(
                    decoration: BoxDecoration(color: Colors.black),
                    child: Text(
                      'Meu Perfil',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock, color: Colors.black),
                    title: const Text('Trocar Senha'),
                    onTap: () {
                      viewModel.forgotPassword(context);
                      Navigator.pop(context); // Fecha o drawer
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.exit_to_app, color: Colors.black),
                    title: const Text('Logout'),
                    onTap: () {
                      Navigator.pop(context);
                      viewModel.logout(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.bar_chart, color: Colors.black),
                    title: const Text('Metas'),
                    onTap: () {
                    Navigator.pop(context);
                    viewModel.navigateToGoals(context);
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
