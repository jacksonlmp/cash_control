import 'package:cash_control/navigation/dashboard_navigation.dart';
import 'package:cash_control/ui/widgets/shared/nav_items.dart';
import 'package:flutter/material.dart';

Container buildBottomNavigationBar(
    viewModel,
    BuildContext context,
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
      currentIndex: viewModel.selectedIndex,
      onTap: (index) {
        viewModel.onItemTapped(index);

        switch (index) {
          case 0:
          // Dashboards
            handleDashboardNavigation(index, context, scaffoldKey);
            break;
          case 1:
          // Categorias
            Navigator.pushNamed(context, '/category');
            break;
          case 2:
          // Botão central de ação (pode navegar para tela de adicionar transação por exemplo)
            Navigator.pushNamed(context, '/financial-entry-registration');
            break;
          case 3:
          // Transações
            Navigator.pushNamed(context, '/financial-entry');
            break;
          case 4:
          // Cambio
            Navigator.pushNamed(context, '/cambio');
            break;
          default:
            break;
        }
      },
      items: buildDashboardNavItems(),
    ),
  );
}
