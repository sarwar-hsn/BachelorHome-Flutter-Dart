import 'package:equatable/equatable.dart';
import 'package:stest/data/models/usermodels/user_entity.dart';

class User extends Equatable {
  final String? email;
  final String id;
  final String? name;
  final List<String>? createdLedgers;
  final List<String>? assignedLedgers;
  final List<String>? declinedLedgers;
  final List<String>? pendingLedgers;

  const User(
      {required this.id,
      this.email,
      this.name,
      this.assignedLedgers,
      this.createdLedgers,
      this.declinedLedgers,
      this.pendingLedgers});

  static const empty = User(id: '');
  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [
        email,
        id,
        name,
      ];

  //copy constructor
  User copyWith(User user, {String? id, String? email, String? name}) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.email,
    );
  }

  //coverting to UserEntity back and forth
  UserEntity toUserEntity() {
    return UserEntity(
      id: id,
      email: email!,
      name: name ?? 'user',
    );
  }

  static User fromUserEntity(UserEntity entity) {
    return User(id: entity.id, email: entity.email, name: entity.name);
  }
}
