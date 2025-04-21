import 'package:cash_control/ui/widgets/cambioApiScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cash_control/data/floor/app_database.dart';
import 'package:cash_control/data/repositories/goal_repository_impl.dart';
import 'package:cash_control/data/repositories/user_repository_impl.dart';
import 'package:cash_control/data/services/goal_service.dart';
import 'package:cash_control/data/services/user_service.dart';

import 'package:cash_control/ui/view_model/register_view_model.dart';
import 'package:cash_control/ui/view_model/financial_report_view_model.dart';
import 'package:cash_control/ui/view_model/goal_registration_view_model.dart';
import 'package:cash_control/ui/view_model/goal_view_model.dart';
import 'package:cash_control/ui/view_model/user_view_model.dart';
import 'package:cash_control/ui/view_model/login_view_model.dart';

import 'package:cash_control/ui/widgets/category.screen.dart';
import 'package:cash_control/ui/widgets/chart_screen.dart';
import 'package:cash_control/ui/widgets/dashboard.screen.dart';
import 'package:cash_control/ui/widgets/financial_entry.screen.dart';
import 'package:cash_control/ui/widgets/financial_entry_registration.screen.dart';
import 'package:cash_control/ui/widgets/financial_report.screen.dart';
import 'package:cash_control/ui/widgets/forgot_password.screen.dart';
import 'package:cash_control/ui/widgets/goal.screen.dart';
import 'package:cash_control/ui/widgets/goal_registration.screen.dart';
import 'package:cash_control/ui/widgets/login.screen.dart';
import 'package:cash_control/ui/widgets/user_registration.screen.dart';
import 'package:cash_control/ui/widgets/welcome.screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;

  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel(UserRepositoryImpl(database))),
        ChangeNotifierProvider(create: (_) => UserViewModel(UserRepositoryImpl(database))),
        ChangeNotifierProvider(create: (_) => GoalRegistrationViewModel(GoalService(GoalRepositoryImpl(database)))),
        ChangeNotifierProvider(create: (_) => GoalViewModel(GoalService(GoalRepositoryImpl(database)))),
        ChangeNotifierProvider(create: (_) => FinancialReportViewModel(database)),
        ChangeNotifierProvider(create: (_) => RegisterViewModel(UserService(UserRepositoryImpl(database)))),
      ],
      child: MaterialApp(
        title: 'CashControl',
        theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
        initialRoute: '/',
        routes: {
          '/': (context) => const WelcomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const UserRegistrationScreen(),
          '/forgot-password': (context) => const ForgotPassword(),
          '/goals': (context) =>  GoalScreen(database: database),
          '/monthly_evolution': (context) => ChartScreen(database: database),
          '/monthly_report': (context) => const FinancialReportScreen(),
          '/cambio': (context) =>  Cambioapiscreen(),
        },
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/goals/register':
              return MaterialPageRoute(builder: (_) => GoalRegistrationScreen(database: database));
            case '/dashboard':
              return MaterialPageRoute(builder: (_) => DashboardScreen(database: database));
            case '/financial-entry':
              return MaterialPageRoute(builder: (_) => FinancialEntryScreen(database: database));
            case '/financial-entry-registration':
              return MaterialPageRoute(builder: (_) => FinancialEntryRegistrationScreen(database: database));
            case '/category':
              return MaterialPageRoute(builder: (_) => CategoryScreen(database: database));
            default:
              return null;
          }
        },
      ),
    );
  }
}
