import 'package:cash_control/data/services/user_service.dart';
import 'package:flutter/material.dart';

class DashboardViewModel extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  final UserService _userService;
  DashboardViewModel(this._userService);

  void onItemTapped(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    await _userService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> forgotPassword(BuildContext context) async {
    await _userService.logout();
    Navigator.pushNamed(context, '/forgot-password');
  }

}
