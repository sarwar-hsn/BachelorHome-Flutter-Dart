part of 'ledger_request_bloc.dart';

@immutable
class LedgerRequestState {
  final String name;
  final int value;
  final DateTime? date;
  final String? assignedId;
  const LedgerRequestState(
      {this.name = '', this.value = 0, this.date, this.assignedId});
  LedgerRequestState copyWith(
      {String? name, int? value, DateTime? date, String? assignedId}) {
    return LedgerRequestState(
        name: name ?? this.name,
        value: value ?? this.value,
        date: date ?? this.date,
        assignedId: assignedId ?? this.assignedId);
  }

  String? nameValidate(String name) {
    if (name.isEmpty) return "no name provided";
    return null;
  }

  String? valueValidate(String value) {
    if (int.tryParse(value) == null) {
      return 'expect number';
    } else if (int.parse(value) < 0) {
      return 'expect positive number';
    }
    return null;
  }
}

class RequestLedgerInitialState extends LedgerRequestState {}

class RequestLedgerSuccessState extends LedgerRequestState {
  final String msg;
  const RequestLedgerSuccessState({required this.msg});
}

class RequestLedgerFailedState extends LedgerRequestState {
  final String msg;
  const RequestLedgerFailedState({required this.msg});
}

//getting pedning ledgers

class PendingLedgerInitState extends LedgerRequestState {}

class PendingLedgerSuccessState extends LedgerRequestState {
  final List<Ledger> ledgers;
  const PendingLedgerSuccessState({required this.ledgers});
}

class PendingLedgerFailedState extends LedgerRequestState {
  final String msg;
  const PendingLedgerFailedState({required this.msg});
}
