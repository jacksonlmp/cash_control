// lib/navigation/dashboard_navigation.dart

import 'package:cash_control/ui/widgets/dashboard.screen.dart';
import 'package:flutter/material.dart';
import '../ui/widgets/category.screen.dart';

void handleDashboardNavigation(int index, BuildContext context) {
  switch (index) {
    case 0:
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ),
      );
      break;
    case 1:
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CategoryScreen(),
        ),
      );
      break;
  }
}
