import 'package:cash_control/domain/models/category.dart';

abstract class CategoryRepository {
  Future<void> register(Category category);
}
