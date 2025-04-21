import 'package:flutter/widgets.dart';

import '../../data/services/user_service.dart';

class GenericModel extends ChangeNotifier {
  final UserService _userService;

  GenericModel(this._userService);

  // Funções para navegação
  Future<void> logout(BuildContext context) async {
    await _userService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> forgotPassword(BuildContext context) async {
    await _userService.logout();
    Navigator.pushNamed(context, '/forgot-password');
  }

  Future<void> navigateToGoalRegistration(BuildContext context) async {
    Navigator.pushNamed(context, '/goal-registration');
  }

  Future<void> navigateToGoals(BuildContext context) async {
    Navigator.pushNamed(context, '/goals');
  }

  Future<void> atualidade(BuildContext context) async {
    Navigator.pushNamed(context, '/atualidade');
  }
}
