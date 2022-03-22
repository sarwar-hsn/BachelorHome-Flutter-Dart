part of 'ledger_log_cubit.dart';

@immutable
abstract class LedgerLogState {}

class LedgerLogInitial extends LedgerLogState {}

class LedgerLogSuccessState extends LedgerLogState {
  final List<LedgerLog> logs;
  LedgerLogSuccessState({required this.logs});
}

class LedgerLogFailedState extends LedgerLogState {
  final String msg;
  LedgerLogFailedState({required this.msg});
}
