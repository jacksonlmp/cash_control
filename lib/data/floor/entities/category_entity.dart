import 'package:floor/floor.dart';

@Entity(tableName: 'category')
class CategoryEntity {
  @primaryKey
  final String id;

  final String name;

  CategoryEntity({required this.id, required this.name});
}