import 'package:cash_control/data/repositories/category_repository_impl.dart';
import 'package:cash_control/data/repositories/financial_entry_repository_impl.dart';
import 'package:cash_control/data/services/category_service.dart';
import 'package:cash_control/data/services/financial_entry_service.dart';
import 'package:cash_control/data/services/user_service.dart';
import 'package:cash_control/ui/widgets/shared/bottom_navigation_bar.dart';
import 'package:cash_control/ui/widgets/shared/dashboard_chart.dart';
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
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late final FinancialEntryService financialEntryService;

  @override
  void initState() {
    super.initState();
    financialEntryService = FinancialEntryService(
      FinancialEntryRepositoryImpl(),
      CategoryService(CategoryRepositoryImpl()),
    );
  }

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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DashboardCharts(
                      financialEntryService: financialEntryService,
                    ),
                  ],
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
