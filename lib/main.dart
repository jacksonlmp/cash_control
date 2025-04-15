import 'package:cash_control/ui/view_model/user_view_model.dart';
import 'package:cash_control/ui/widgets/dashboard.screen.dart';
import 'package:cash_control/ui/widgets/forgot_password.screen.dart';
import 'package:cash_control/ui/widgets/login.screen.dart';
import 'package:cash_control/ui/widgets/user_registration.screen.dart';
import 'package:cash_control/ui/widgets/welcome.screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cash_control/ui/view_model/login_view_model.dart';
import 'package:cash_control/data/repositories/user_repository_impl.dart';

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
          create: (_) => LoginViewModel(UserRepositoryImpl()),
        ),
        ChangeNotifierProvider(
          create: (_) => UserViewModel(UserRepositoryImpl()),
        ),
      ],
      child: MaterialApp(
        title: 'CashControl',
        theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
        initialRoute: '/',
        routes: {
          '/': (context) => const WelcomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const UserRegistrationScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/forgot-password': (context) => const ForgotPassword(),     
        },
      ),
    );
  }
}
