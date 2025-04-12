import '../../domain/models/category.dart';

class CategoryModel extends Category {
  CategoryModel({
    required super.id,
    required super.name
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name']
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name
  };
}
