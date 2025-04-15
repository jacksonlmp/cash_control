import 'package:flutter/widgets.dart';

import '../../data/services/user_service.dart';

class GenericModel extends ChangeNotifier {

  final UserService _userService;
  GenericModel(this._userService);

  Future<void> logout(BuildContext context) async {
    await _userService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> forgotPassword(BuildContext context) async {
    await _userService.logout();
    Navigator.pushNamed(context, '/forgot-password');
  }
}