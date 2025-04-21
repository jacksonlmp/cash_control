import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cash_control/data/floor/app_database.dart';
import 'package:cash_control/data/repositories/category_repository_impl.dart';
import 'package:cash_control/data/repositories/financial_entry_repository_impl.dart';
import 'package:cash_control/data/repositories/user_repository_impl.dart';
import 'package:cash_control/data/services/category_service.dart';
import 'package:cash_control/data/services/financial_entry_service.dart';
import 'package:cash_control/data/services/user_service.dart';
import 'package:cash_control/ui/widgets/shared/bottom_navigation_bar.dart';
import 'package:cash_control/ui/widgets/shared/dashboard_chart.dart';
import 'package:cash_control/ui/widgets/shared/end_drawer.dart';
import 'package:cash_control/ui/view_model/dashboard_view_model.dart';

class DashboardScreen extends StatefulWidget {
  final AppDatabase database;

  const DashboardScreen({super.key, required this.database});

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
      FinancialEntryRepositoryImpl(widget.database),
      CategoryService(CategoryRepositoryImpl(widget.database.categoryDao)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel(
        UserService(UserRepositoryImpl(widget.database)),
      ),
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
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DashboardCharts(financialEntryService: financialEntryService),
                  ],
                ),
              ),
            ),
            endDrawer: buildEndDrawer(context, widget.database),
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
