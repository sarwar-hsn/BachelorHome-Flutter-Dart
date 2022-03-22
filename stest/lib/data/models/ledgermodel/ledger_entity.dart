import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class LedgerEntity extends Equatable {
  final String id;
  final String name;
  final int value;
  final DateTime date;
  final String creatorId;
  final String assignedId;
  final bool isActive;
  final int currentValue;

  const LedgerEntity({
    required this.id,
    required this.name,
    required this.value,
    required this.date,
    required this.creatorId,
    required this.assignedId,
    required this.isActive,
    required this.currentValue,
  });

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'date': date,
      'creatorId': creatorId,
      'assignedId': assignedId,
      'isActive': isActive,
      'currentValue': currentValue,
    };
  }

  Map<String, Object> toDocument() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'date': date,
      'creatorId': creatorId,
      'assignedId': assignedId,
      'isActive': isActive,
      'currentValue': currentValue,
    };
  }

  static LedgerEntity fromSnapShot(DocumentSnapshot snap) {
    return LedgerEntity(
      id: snap.id,
      currentValue: (snap.data() as dynamic)['currentValue'].toInt(),
      name: (snap.data() as dynamic)['name'],
      value: (snap.data() as dynamic)['value'].toInt(),
      date: (snap.data() as dynamic)['date'].toDate(),
      creatorId: (snap.data() as dynamic)['creatorId'],
      assignedId: (snap.data() as dynamic)['assignedId'],
      isActive: (snap.data() as dynamic)['isActive'],
    );
  }

  static LedgerEntity fromQuery(QueryDocumentSnapshot snap) {
    return LedgerEntity(
      id: snap.id,
      currentValue: (snap.data() as dynamic)['currentValue'].toInt(),
      name: (snap.data() as dynamic)['name'],
      value: (snap.data() as dynamic)['value'].toInt(),
      date: (snap.data() as dynamic)['date'].toDate(),
      creatorId: (snap.data() as dynamic)['creatorId'],
      assignedId: (snap.data() as dynamic)['assignedId'],
      isActive: (snap.data() as dynamic)['isActive'],
    );
  }

  static LedgerEntity fromJson(Map<String, Object> obj) {
    return LedgerEntity(
        name: obj['name'] as String,
        value: obj['value'] as int,
        currentValue: obj['currentValue'] as int,
        date: obj['date'] as DateTime,
        creatorId: obj['creatorId'] as String,
        assignedId: obj['assignedId'] as String,
        isActive: obj['isActive'] as bool,
        id: obj['id'] as String);
  }

  @override
  List<Object?> get props =>
      [name, value, date, creatorId, assignedId, isActive, currentValue];
}
