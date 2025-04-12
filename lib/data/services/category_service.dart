import 'package:cash_control/domain/models/category.dart';
import 'package:cash_control/data/repositories/category_repository.dart';
import 'package:uuid/uuid.dart';

class CategoryService {
  final CategoryRepository repository;

  CategoryService(this.repository);

  Future<void> registerCategory({
    required String name
  }) async {
    final category = Category(
      id: const Uuid().v4(),
      name: name
    );

    await repository.register(category);
  }
}
