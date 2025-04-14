import 'package:cash_control/data/repositories/user_repository_impl.dart';
import 'package:cash_control/data/services/user_service.dart';
import 'package:cash_control/ui/view_model/dashboard_view_model.dart';
import 'package:cash_control/ui/widgets/shared/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cash_control/ui/widgets/shared/custom_text_field.dart';
import 'package:cash_control/ui/widgets/shared/custom_form.dart';
import 'package:cash_control/ui/view_model/category_registration_view_model.dart';

class CategoryRegistrationScreen extends StatelessWidget {
  const CategoryRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel(UserService(UserRepositoryImpl())),
      child: Consumer<CategoryRegistrationViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: const Text(
                'Cadastrar Categoria',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.black,
              shape: const Border(
                bottom: BorderSide(color: Colors.white, width: 1.5),
              ),
            ),
            body: Container(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: CustomForm(
                  isLoading: viewModel.isLoading,
                  buttonText: 'Cadastrar',
                  onSubmit: () async {
                    await viewModel.registerCategory();
                    if (viewModel.errorMessage.isEmpty) {
                      // Sucesso
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.grey[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            title: const Text(
                              'Sucesso',
                              style: TextStyle(color: Colors.white),
                            ),
                            content: const Text(
                              'Categoria cadastrada com sucesso!',
                              style: TextStyle(color: Colors.white70),
                            ),
                            actions: [
                              TextButton(
                                child: const Text(
                                  'OK',
                                  style: TextStyle(color: Color(0xFFA100FF)),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  formFields: [
                    CustomTextField(
                      label: 'Nome',
                      onChanged: viewModel.setName,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um nome';
                        }
                        return null;
                      },
                    ),
                    if (viewModel.errorMessage.isNotEmpty)
                      Text(
                        viewModel.errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: buildBottomNavigationBar(viewModel, context, scaffoldKey),
          );
        },
      ),
    );
  }
}
