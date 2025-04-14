
import 'package:cash_control/navigation/dashboard_navigation.dart';
import 'package:cash_control/ui/widgets/shared/nav_items.dart';
import 'package:flutter/material.dart';

Container buildBottomNavigationBar(viewModel, context){
  return Container(
    decoration: const BoxDecoration(
      border: Border(
        top: BorderSide(color: Colors.white, width: 1.5),
      ),
    ),
    child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        onTap: (index) {
          viewModel.onItemTapped(index);
          handleDashboardNavigation(index, context);
        },
        items: buildDashboardNavItems()
    ),
  );
}