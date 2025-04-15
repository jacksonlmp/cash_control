import 'package:cash_control/data/repositories/user_repository_impl.dart';
import 'package:cash_control/data/services/user_service.dart';
import 'package:cash_control/ui/view_model/generic_model.dart';
import 'package:flutter/material.dart';

Drawer buildEndDrawer(context){
  var viewModel = GenericModel(UserService(UserRepositoryImpl()));
  return Drawer(
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
            Navigator.pop(context);
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
      ],
    ),
  );
}