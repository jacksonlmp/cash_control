import 'package:flutter/material.dart';
List<BottomNavigationBarItem> buildDashboardNavItems() {
  return const [
    BottomNavigationBarItem(
      icon: Icon(Icons.dashboard, color: Colors.white),
      label: 'Dashboards',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.category, color: Colors.white),
      label: 'Categorias',
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(top: 1.0),
        child: Icon(Icons.add, size: 45, color: Colors.white),
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.attach_money, color: Colors.white),
      label: 'Transações',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_balance_wallet, color: Colors.white),
      label: 'Cambio',
    ),
  ];
}
