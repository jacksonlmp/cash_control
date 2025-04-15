// lib/navigation/dashboard_navigation.dart
import 'package:flutter/material.dart';

void handleDashboardNavigation(int index, BuildContext context, scaffoldKey) {
  switch (index) {
    case 0:
      Navigator.pushReplacementNamed(context, '/dashboard');
      break;
    case 1:
      Navigator.pushReplacementNamed(context, '/category');
      break;
    case 2:
      Navigator.pushReplacementNamed(context, '/financial-entry-registration');
      break;
    case 3:
      Navigator.pushReplacementNamed(context, '/financial-entry');
      break;
    case 4:
      scaffoldKey.currentState?.openEndDrawer();
      break;
  }
}
