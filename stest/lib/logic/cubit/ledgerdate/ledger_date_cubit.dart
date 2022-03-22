import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:stest/data/models/ledgermodel/ledger_entity.dart';
import 'package:stest/data/repositories/ledger_repository/ledger_repository.dart';

import '../../../data/models/ledgermodel/ledger.dart';

part 'ledger_date_state.dart';

class LedgerDateCubit extends Cubit<LedgerDateState> {
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _ledgersStream;
  LedgerDateCubit() : super(LedgerDateState()) {
    try {
      _ledgersStream = LedgerRepository()
          .getLedgerByMonth(month: state.month!, year: state.year!)
          .listen((snapshots) {
        emit(GetLedgersSuccessState(
            ledgers: snapshots.docs
                .map((snap) =>
                    Ledger.fromLedgerEntity(LedgerEntity.fromQuery(snap)))
                .toList(),
            pickedMonth: state.month!,
            pickedYear: state.year!));
      });
    } catch (e) {
      GetLedgersFailedState(msg: e.toString());
    }
  }

  void getLedgers(int month, int year) {
    try {
      state.copyWith(month, year);
      _ledgersStream = LedgerRepository()
          .getLedgerByMonth(month: month, year: year)
          .listen((snapshots) {
        emit(GetLedgersSuccessState(
            ledgers: snapshots.docs
                .map((snap) =>
                    Ledger.fromLedgerEntity(LedgerEntity.fromQuery(snap)))
                .toList(),
            pickedMonth: month,
            pickedYear: year));
      });
    } catch (e) {
      GetLedgersFailedState(msg: e.toString());
    }
  }

  @override
  Future<void> close() {
    _ledgersStream.cancel();
    return super.close();
  }
}
