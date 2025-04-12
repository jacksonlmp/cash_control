import 'package:cash_control/ui/view_model/register_view_model.dart';
import 'package:cash_control/ui/widgets/dashboard.screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/repositories/user_repository_impl.dart';
import 'data/services/user_service.dart';

void main() {
  final repository = UserRepositoryImpl();
  final service = UserService(repository);
  final viewModel = RegisterViewModel(service);

  runApp(MyApp(viewModel));
}

class MyApp extends StatelessWidget {
  final RegisterViewModel viewModel;

  const MyApp(this.viewModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: MaterialApp(
        title: 'Cadastro',
        home: const DashboardScreen(),
      ),
    );
  }
}
