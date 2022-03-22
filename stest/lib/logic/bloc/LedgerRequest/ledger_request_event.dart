part of 'ledger_request_bloc.dart';

@immutable
class LedgerRequestEvent {}

class NameChangeEvent extends LedgerRequestEvent {
  final String name;
  NameChangeEvent({required this.name});
}

class UserChangeEvent extends LedgerRequestEvent {
  final String assignedId;
  UserChangeEvent({required this.assignedId});
}

class DateChangeEvent extends LedgerRequestEvent {
  final DateTime date;
  DateChangeEvent({required this.date});
}

class ValueChangeEvent extends LedgerRequestEvent {
  final String value;
  ValueChangeEvent({required this.value});
}

class AddToRequestedLedgerEvent extends LedgerRequestEvent {
  final Ledger ledger;
  AddToRequestedLedgerEvent({required this.ledger});
}

class AddToPendingLedgerEvent extends LedgerRequestEvent {
  final String ledgerId;
  AddToPendingLedgerEvent({required this.ledgerId});
}

class GetPendingLedgersEvent extends LedgerRequestEvent {
  final List<Ledger> ledgers;
  GetPendingLedgersEvent({required this.ledgers});
}
