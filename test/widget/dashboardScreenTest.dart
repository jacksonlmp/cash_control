import 'package:cash_control/data/services/user_service.dart';
import 'package:cash_control/ui/view_model/dashboard_view_model.dart';
import 'package:cash_control/ui/widgets/dashboard.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../mocks/mocksTest.mocks.dart';

void main() {
  late MockAppDatabase mockDatabase;
  late MockUserRepository mockUserRepository;
  late UserService userService;

  setUp(() {
    mockDatabase = MockAppDatabase();
    mockUserRepository = MockUserRepository();
    userService = UserService(mockUserRepository);
  });

  Widget createWidgetUnderTest() {
    return ChangeNotifierProvider<DashboardViewModel>(
      create: (_) => DashboardViewModel(userService),
      child: MaterialApp(
        home: DashboardScreen(database: mockDatabase),
      ),
    );
  }

  testWidgets('Deve exibir título e navegação do dashboard', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Cambio'), findsOneWidget);
  });
}
