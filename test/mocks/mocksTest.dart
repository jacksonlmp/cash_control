import 'package:cash_control/data/floor/app_database.dart';
import 'package:cash_control/data/floor/dao/category_dao.dart';
import 'package:cash_control/data/services/financial_entry_service.dart';
import 'package:cash_control/ui/view_model/category_registration_view_model.dart';
import 'package:cash_control/ui/view_model/category_view_model.dart';
import 'package:cash_control/ui/view_model/dashboard_view_model.dart';
import 'package:cash_control/ui/view_model/financial_entry_edit_view_model.dart';
import 'package:cash_control/ui/view_model/financial_entry_registration_view_model.dart';
import 'package:cash_control/ui/view_model/financial_entry_view_model.dart';
import 'package:cash_control/ui/view_model/goal_registration_view_model.dart';
import 'package:cash_control/ui/view_model/goal_view_model.dart';
import 'package:cash_control/ui/view_model/login_view_model.dart';
import 'package:cash_control/ui/view_model/monthly_financial_chart_view_model.dart';
import 'package:cash_control/ui/view_model/user_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:cash_control/data/repositories/user_repository.dart';
import 'package:cash_control/data/repositories/goal_repository.dart';
import 'package:cash_control/data/repositories/category_repository.dart';
import 'package:cash_control/data/repositories/financial_entry_repository.dart';
import 'package:cash_control/data/repositories/financial_report_repository.dart';
import 'package:cash_control/data/repositories/financial_summary_repository.dart';
import 'package:flutter/widgets.dart';

@GenerateNiceMocks([
  MockSpec<UserRepository>(),
  MockSpec<GoalRepository>(),
  MockSpec<CategoryRepository>(),
  MockSpec<FinancialEntryRepository>(),
  MockSpec<FinancialReportRepository>(),
  MockSpec<FinancialSummaryRepository>(),
  MockSpec<FinancialEntryService>(),
  MockSpec<NavigatorObserver>(),
  MockSpec<UserViewModel>(),
  MockSpec<LoginViewModel>(),
  MockSpec<GoalRegistrationViewModel>(),
  MockSpec<GoalViewModel>(),
  MockSpec<FinancialEntryRegistrationViewModel>(),
  MockSpec<FinancialEntryViewModel>(),
  MockSpec<FinancialEntryEditViewModel>(),
  MockSpec<CategoryRegistrationViewModel>(),
  MockSpec<CategoryViewModel>(),
  MockSpec<MonthlyFinancialChart>(),
  MockSpec<DashboardViewModel>(),
  MockSpec<AppDatabase>(),
  MockSpec<CategoryDao>()
])

void main() {}


