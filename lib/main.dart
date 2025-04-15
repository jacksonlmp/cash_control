import 'package:cash_control/ui/view_model/goal_registration_view_model.dart';
import 'package:cash_control/ui/view_model/goal_view_model.dart';
import 'package:cash_control/ui/view_model/user_view_model.dart';
import 'package:cash_control/ui/view_model/login_view_model.dart';
import 'package:cash_control/data/repositories/user_repository_impl.dart';
import 'package:cash_control/ui/widgets/dashboard.screen.dart';
import 'package:cash_control/ui/widgets/forgot_password.screen.dart';
import 'package:cash_control/ui/widgets/goal.screen.dart';
import 'package:cash_control/ui/widgets/goal_registration.screen.dart';
import 'package:cash_control/ui/widgets/login.screen.dart';
import 'package:cash_control/ui/widgets/user_registration.screen.dart';
import 'package:cash_control/ui/widgets/welcome.screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/services/goal_service.dart';

void main() {
  // Certifique-se de que o Flutter está inicializado antes de executar qualquer código dependente da plataforma
  WidgetsFlutterBinding.ensureInitialized();
  // deleta o banco
  // DatabaseHelper().deleteDatabaseFile();
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
        ChangeNotifierProvider(
          create: (_) => GoalRegistrationViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => GoalViewModel(GoalService()),
        ),
        ChangeNotifierProvider(create: (_) => FinancialReportViewModel(),
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
          '/financial-entry': (context) => const FinancialEntryScreen(),
          '/financial-entry-registration': (context) => const FinancialEntryRegistrationScreen(),
          '/category': (context) => const CategoryScreen(),
          '/goals': (context) => const GoalScreen(),
          '/goals/register': (context) => const GoalRegistrationScreen(),
          '/monthly_evolution': (context) =>  ChartScreen(),
          '/monthly_report': (context) => const FinancialReportScreen(),
        },
      ),
    );
  }
}

