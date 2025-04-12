// lib/ui/user/widgets/user_registration_screen.dart
import 'package:cash_control/ui/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserRegistrationScreen extends StatelessWidget {
  const UserRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<UserViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                TextField(
                  onChanged: viewModel.setName,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  onChanged: viewModel.setEmail,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  onChanged: viewModel.setPassword,
                  decoration: const InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                if (viewModel.errorMessage.isNotEmpty)
                  Text(
                    viewModel.errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 20),
                viewModel.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: viewModel.registerUser,
                        child: const Text('Cadastrar'),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}
