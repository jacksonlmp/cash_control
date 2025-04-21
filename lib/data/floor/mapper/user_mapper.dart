// lib/data/floor/mapper/user_mapper.dart
import '../../../domain/models/user.dart';
import '../entities/user_entity.dart';

extension UserMapper on User {
  UserEntity toEntity() => UserEntity(
    id: id,
    name: name,
    email: email,
    password: password,
  );
}

extension UserEntityMapper on UserEntity {
  User toModel() => User(
    id: id,
    name: name,
    email: email,
    password: password,
  );
}
