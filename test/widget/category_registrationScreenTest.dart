import 'package:cash_control/ui/view_model/category_registration_view_model.dart';
import 'package:cash_control/ui/widgets/category_registration.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../mocks/mocksTest.mocks.dart';

void main() {
  late MockCategoryRegistrationViewModel mockViewModel;
  late MockAppDatabase mockDatabase;
  late MockCategoryDao mockCategoryDao;

  setUp(() {
    mockDatabase = MockAppDatabase();
    mockCategoryDao = MockCategoryDao();
    mockViewModel = MockCategoryRegistrationViewModel();

    when(mockDatabase.categoryDao).thenReturn(mockCategoryDao);

    when(mockViewModel.isLoading).thenReturn(false);
    when(mockViewModel.errorMessage).thenReturn('');
    when(mockViewModel.setName(any)).thenReturn(null);
    when(mockViewModel.registerCategory()).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      routes: {'/category': (context) => const Scaffold()},
      home: ChangeNotifierProvider<CategoryRegistrationViewModel>.value(
        value: mockViewModel,
        child: CategoryRegistrationScreen(database: mockDatabase),
      ),
    );
  }

  testWidgets('Deve renderizar os campos e botão de cadastro', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Nome'), findsOneWidget);
    expect(find.text('Cadastrar'), findsOneWidget);
  });
}
