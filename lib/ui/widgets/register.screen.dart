import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/register_view_model.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: vm.nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: vm.emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: vm.passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            TextField(
              controller: vm.confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirme a Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (vm.error != null)
              Text(vm.error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: vm.isLoading ? null : vm.register,
              child: vm.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}

