import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cash_control/domain/models/category.dart';
import 'package:cash_control/data/services/category_service.dart';
import '../mocks/mocksTest.mocks.dart';

void main() {
  late CategoryService categoryService;
  late MockCategoryRepository mockCategoryRepository;

  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
    categoryService = CategoryService(mockCategoryRepository);
  });

  final mockCategory = Category(id: '1', name: 'Alimentação');

  group('CategoryService Tests', () {
    test('deve registrar uma categoria', () async {
      when(mockCategoryRepository.register(mockCategory)).thenAnswer((_) async {});

      await categoryService.registerCategory(mockCategory);

      verify(mockCategoryRepository.register(mockCategory)).called(1);
    });

    test('deve retornar uma lista de categorias', () async {
      when(mockCategoryRepository.findAll()).thenAnswer((_) async => [mockCategory]);

      final result = await categoryService.findAllCategories();

      expect(result.length, 1);
      expect(result.first.id, '1');
      expect(result.first.name, 'Alimentação');
      verify(mockCategoryRepository.findAll()).called(1);
    });

    test('deve retornar lista vazia quando não houver categorias', () async {
      when(mockCategoryRepository.findAll()).thenAnswer((_) async => []);

      final result = await categoryService.findAllCategories();

      expect(result, isEmpty);
      verify(mockCategoryRepository.findAll()).called(1);
    });

    test('deve deletar uma categoria', () async {
      when(mockCategoryRepository.delete('1')).thenAnswer((_) async {});

      await categoryService.deleteCategory('1');

      verify(mockCategoryRepository.delete('1')).called(1);
    });

    test('deve falhar ao registrar categoria se o repositório falhar', () async {
      when(mockCategoryRepository.register(mockCategory)).thenThrow(Exception('Falha ao salvar categoria'));

      expect(
            () async => await categoryService.registerCategory(mockCategory),
        throwsA(isA<Exception>()),
      );
    });

    test('deve falhar ao deletar categoria se o repositório falhar', () async {
      when(mockCategoryRepository.delete('1')).thenThrow(Exception('Falha ao deletar categoria'));

      expect(
            () async => await categoryService.deleteCategory('1'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
