import '../../../data/models/ledgermodel/ledger.dart';

abstract class LedgerState {}

class LedgerInitialState extends LedgerState {}

//adding ledger states
class ApproveLedgerInitiateState extends LedgerState {}

class ApproveLedgerSuccessState extends LedgerState {
  String msg;
  ApproveLedgerSuccessState({required this.msg});
}

class ApproveLedgerFailedState extends LedgerState {
  String msg;
  ApproveLedgerFailedState({required this.msg});
}

//get all ledgers state
class GetAllLedgerInitState extends LedgerState {}

class GetAllLedgerSuccessState extends LedgerState {
  final List<Ledger> ledgers;
  GetAllLedgerSuccessState({required this.ledgers});
}

class GetAllLedgerFailedState extends LedgerState {
  String msg;
  GetAllLedgerFailedState({required this.msg});
}

//quering the ledgers
class QueryInitState extends LedgerState {}

class QuerySuccessState extends LedgerState {
  List<Ledger> ledgers;
  QuerySuccessState({required this.ledgers});
}

class QueryFailedState extends LedgerState {
  String msg;
  QueryFailedState({required this.msg});
}

//get ledger state
class GetLedgerByIdInitState extends LedgerState {}

class GetLedgerByIdSuccessState extends LedgerState {
  final Ledger ledger;
  GetLedgerByIdSuccessState({required this.ledger});
}

class GetLedgerByIdFailedState extends LedgerState {
  final String msg;
  GetLedgerByIdFailedState({required this.msg});
}
