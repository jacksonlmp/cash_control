import 'package:cash_control/data/floor/app_database.dart';
import 'package:cash_control/data/repositories/user_repository_impl.dart';
import 'package:cash_control/data/services/user_service.dart';
import 'package:cash_control/ui/view_model/generic_model.dart';
import 'package:flutter/material.dart';

Drawer buildEndDrawer(BuildContext context, AppDatabase database) {
  final viewModel = GenericModel(UserService(UserRepositoryImpl(database)));

  return Drawer(
    backgroundColor: Colors.grey[900],
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
          leading: const Icon(Icons.bar_chart, color: Colors.white),
          title: const Text('Metas', style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.pop(context);
            viewModel.navigateToGoals(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.show_chart, color: Colors.white),
          title: const Text('Evolução Mensal', style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/monthly_evolution');
          },
        ),
        ListTile(
          leading: const Icon(Icons.account_balance_outlined, color: Colors.white),
          title: const Text('Relatório Mensal', style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/monthly_report');
          },
        ),
        ListTile(
          leading: const Icon(Icons.lock, color: Colors.white),
          title: const Text('Trocar Senha', style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.pop(context);
            viewModel.forgotPassword(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app, color: Colors.white),
          title: const Text('Logout', style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.pop(context);
            viewModel.logout(context);
          },
        ),
      ],
    ),
  );
}
