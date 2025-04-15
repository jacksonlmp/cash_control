import 'package:cash_control/navigation/dashboard_navigation.dart';
import 'package:cash_control/ui/widgets/shared/nav_items.dart';
import 'package:flutter/material.dart';

Container buildBottomNavigationBar(
  viewModel,
  context,
  GlobalKey<ScaffoldState> scaffoldKey,
) {
  return Container(
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: Colors.white, width: 1.5)),
    ),
    child: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      currentIndex:
          viewModel.selectedIndex,
      onTap: (index) {
        viewModel.onItemTapped(index);
        if (index == 4) {
          // Índice do "Meu perfil"
          scaffoldKey.currentState?.openEndDrawer();
        } else {
          handleDashboardNavigation(index, context);
        }
      },
      items: buildDashboardNavItems(),
    ),
  );
}
