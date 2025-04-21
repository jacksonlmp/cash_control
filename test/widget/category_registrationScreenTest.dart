import 'package:cash_control/ui/view_model/category_registration_view_model.dart';
import 'package:cash_control/ui/widgets/category_registration.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../mocks/mocksTest.mocks.dart';

void main() {
  late MockCategoryRegistrationViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockCategoryRegistrationViewModel();

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
        child: const CategoryRegistrationScreen(),
      ),
    );
  }

  testWidgets('Deve renderizar os campos e botão de cadastro', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Nome'), findsOneWidget);
    expect(find.text('Cadastrar'), findsOneWidget);
  });

  testWidgets('Deve exibir mensagem de erro quando presente', (tester) async {
    when(mockViewModel.errorMessage).thenReturn('Erro ao cadastrar');

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Erro ao cadastrar'), findsOneWidget);
  });

  testWidgets('Deve chamar registerCategory ao enviar o formulário', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Preencher campo
    await tester.enterText(find.byType(TextFormField), 'Nova Categoria');
    await tester.tap(find.text('Cadastrar'));
    await tester.pump();

    verify(mockViewModel.setName('Nova Categoria')).called(1);
    verify(mockViewModel.registerCategory()).called(1);
  });
}
