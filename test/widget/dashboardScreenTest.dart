import 'package:cash_control/data/services/user_service.dart';
import 'package:cash_control/ui/view_model/dashboard_view_model.dart';
import 'package:cash_control/ui/widgets/dashboard.screen.dart';
import 'package:cash_control/ui/widgets/shared/dashboard_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';

import '../mocks/mocksTest.mocks.dart';

@GenerateMocks([MockUserRepository])
void main() {
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (_) => DashboardViewModel(UserService(mockUserRepository)),
        child: const DashboardScreen(),
      ),
    );
  }

  testWidgets('Deve renderizar título, gráfico e barra de navegação', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Verifica título da AppBar
    expect(find.text('Dashboard'), findsOneWidget);

    // Verifica se o DashboardCharts aparece
    expect(find.byType(DashboardCharts), findsOneWidget);

    // Verifica se há a BottomNavigationBar
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}
