part of 'ledger_date_cubit.dart';

class LedgerDateState {
  final int? month;
  final int? year;
  LedgerDateState({month, year})
      : month = (month != null)
            ? month
            : int.parse(DateFormat('M').format(DateTime.now())),
        year = (year != null)
            ? year
            : int.parse(DateFormat('y').format(DateTime.now()));
  LedgerDateState copyWith(int? month, int? year) {
    return LedgerDateState(
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }
}

class GetLedgersInitialState extends LedgerDateState {}

class GetLedgersSuccessState extends LedgerDateState {
  final List<Ledger> ledgers;
  final int pickedMonth;
  final int pickedYear;
  GetLedgersSuccessState({
    required this.ledgers,
    required this.pickedMonth,
    required this.pickedYear,
  });
}

class GetLedgersFailedState extends LedgerDateState {
  final String msg;
  GetLedgersFailedState({required this.msg});
}
