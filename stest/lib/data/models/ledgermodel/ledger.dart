import 'package:stest/data/models/ledgermodel/ledger_entity.dart';
import 'package:equatable/equatable.dart';

class Ledger extends Equatable {
  final String id;
  final String name;
  final int value;
  final DateTime date;
  final String creatorId;
  final String assignedId;
  final bool isActive;
  final int currentValue;

  const Ledger(
      {required this.id,
      required this.name,
      required this.value,
      required this.assignedId,
      required this.creatorId,
      required this.date,
      required this.isActive,
      required this.currentValue});

  static Ledger fromLedgerEntity(LedgerEntity obj) {
    return Ledger(
        id: obj.id,
        name: obj.name,
        value: obj.value,
        assignedId: obj.assignedId,
        date: obj.date,
        creatorId: obj.creatorId,
        isActive: obj.isActive,
        currentValue: obj.currentValue);
  }

  LedgerEntity toLedgerEntity() {
    return LedgerEntity(
        id: id,
        name: name,
        value: value,
        creatorId: creatorId,
        date: date,
        assignedId: assignedId,
        isActive: isActive,
        currentValue: currentValue);
  }

  @override
  String toString() {
    return "ledger : {id: $id, name: $name, value: $value,currentvalue: $currentValue date: $date, creatorId: $creatorId, assignedId: $assignedId, isActive: $isActive}";
  }

  @override
  List<Object?> get props =>
      [id, name, value, assignedId, date, creatorId, isActive];
}
