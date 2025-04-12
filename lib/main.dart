// lib/main.dart
import 'package:cash_control/ui/view_model/user_view_model.dart';
import 'package:cash_control/ui/widgets/user_registration.screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cash_control/data/repositories/user_repository_impl.dart';
import 'package:cash_control/data/services/user_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserViewModel(UserService(UserRepositoryImpl())),
        ),
      ],
      child: MaterialApp(
        title: 'CashControl',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const UserRegistrationScreen(),
      ),
    );
  }
}
