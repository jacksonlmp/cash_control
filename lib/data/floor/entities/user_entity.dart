// lib/data/floor/entities/user_entity.dart
import 'package:floor/floor.dart';

@Entity(tableName: 'users')
class UserEntity {
  @primaryKey
  final String id;
  final String name;
  final String email;
  final String password;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });
}
