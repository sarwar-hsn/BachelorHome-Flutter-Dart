import 'package:flutter/foundation.dart';

@immutable
abstract class UserEvent {}

//get user events
class GetUserEvent extends UserEvent {}

class GetAllUserEvent extends UserEvent {}

class AcceptingLedgerEvent extends UserEvent {
  final String userId;
  final String ledgerId;
  AcceptingLedgerEvent({required this.userId, required this.ledgerId});
}

class RejectingLedgerEvent extends UserEvent {
  final String userId;
  final String ledgerId;
  RejectingLedgerEvent({required this.userId, required this.ledgerId});
}
