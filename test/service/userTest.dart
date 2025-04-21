import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cash_control/domain/models/user.dart';
import 'package:cash_control/data/services/user_service.dart';
import '../mocks/mocksTest.mocks.dart';

void main() {
  late UserService userService;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    userService = UserService(mockUserRepository);
  });

  test('Deve lançar exceção se o email for inválido', () async {
    final user = User(email: 'invalido', password: 'Df@12345', id: '1', name: 'test');
    when(mockUserRepository.existsEmail(any)).thenAnswer((_) async => false);

    expect(
          () => userService.registerUser(user),
      throwsA(predicate((e) =>
      e is Exception && e.toString().contains('Email inválido'))),
    );
  });

  test('Deve lançar exceção se a senha for fraca', () async {
    final user = User(email: 'teste@email.com', password: '123', id: '1', name: 'test');
    when(mockUserRepository.existsEmail(any)).thenAnswer((_) async => false);

    expect(
          () => userService.registerUser(user),
      throwsA(predicate((e) =>
      e is Exception && e.toString().contains('Senha fraca'))),
    );
  });

  test('Deve lançar exceção se o email já estiver cadastrado', () async {
    final user = User(email: 'teste@email.com', password: 'Df@12345', id: '1', name: 'test');
    when(mockUserRepository.existsEmail(user.email)).thenAnswer((_) async => true);

    expect(
          () => userService.registerUser(user),
      throwsA(predicate((e) =>
      e is Exception && e.toString().contains('E-mail já está em uso'))),
    );
  });

  test('Deve cadastrar usuário com sucesso se tudo estiver ok', () async {
    final user = User(email: 'teste@email.com', password: 'Df@12345', id: '1', name: 'test');

    when(mockUserRepository.existsEmail(user.email)).thenAnswer((_) async => false);
    when(mockUserRepository.register(user)).thenAnswer((_) async => Future.value());

    await userService.registerUser(user);

    verify(mockUserRepository.register(user)).called(1);
  });
}




