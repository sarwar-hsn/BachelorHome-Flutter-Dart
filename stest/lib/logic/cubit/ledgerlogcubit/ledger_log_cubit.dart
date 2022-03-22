import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../../data/models/transactions/ledger_log.dart';
import '../../../data/repositories/transaction_repository/ledger_log_repository.dart';

part 'ledger_log_state.dart';

class LedgerLogCubit extends Cubit<LedgerLogState> {
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _logsSubscription;
  final String ledgerId;
  LedgerLogCubit({required this.ledgerId}) : super(LedgerLogInitial()) {
    try {
      _logsSubscription = LedgerLogRepository()
          .getLedgerLog(ledgerId: ledgerId)
          .listen((event) {
        emit(LedgerLogSuccessState(
            logs: event.docs
                .map((log) => LedgerLog.fromQuerySnapShot(log))
                .toList()));
      });
    } catch (e) {
      emit(LedgerLogFailedState(msg: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _logsSubscription.cancel();
    return super.close();
  }
}
