import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;

  const UserEntity({required this.id, required this.email, required this.name});

  @override
  String toString() {
    return 'userEntity { id : $id, name : $name, email : $email }';
  }

  //to deal with user  model
  Map<String, Object> toJson() {
    return {'id': id, 'name': name, 'email': email};
  }

  //to deal with firestore specifically
  Map<String, Object> toDocument() {
    return {'email': email, 'name': name};
  }

  //dealing with user model class
  static UserEntity fromJson(Map<String, Object> json) {
    return UserEntity(
        id: json['id'] as String,
        email: json['email'] as String,
        name: json['name'] as String);
  }

  //deal with firestore
  static UserEntity fromSnapshot(DocumentSnapshot doc) {
    return UserEntity(
        name: (doc.data() as dynamic)['name'],
        email: (doc.data() as dynamic)['email'],
        id: doc.id);
  }

  @override
  List<Object?> get props => [id, email, name];
}
