import 'package:stest/data/models/ledgermodel/ledger.dart';

abstract class LedgerEvent {}

class ApproveLedgerState extends LedgerEvent {
  final Ledger ledger;
  ApproveLedgerState({required this.ledger});
}

//listening to stream
class GetAllLedgerEvent extends LedgerEvent {}
//class send ledgers event

class SendActiveLedgersEvent extends LedgerEvent {
  final List<Ledger> activeLedgers;
  SendActiveLedgersEvent({required this.activeLedgers});
}

class GetLedgerByMonthYearEvent extends LedgerEvent {
  final int month;
  final int year;
  GetLedgerByMonthYearEvent({required this.month, required this.year});
}

class GetLedgerDateEvent extends LedgerEvent {}

class GetLedgerByActiveStatusEvent extends LedgerEvent {}

//getLedgerbyIdevent
class GetLedgerByIdEvent extends LedgerEvent {
  final String ledgerid;
  GetLedgerByIdEvent({required this.ledgerid});
}

class SendLedgerFromIdEvent extends LedgerEvent {
  final Ledger ledger;
  SendLedgerFromIdEvent({required this.ledger});
}
