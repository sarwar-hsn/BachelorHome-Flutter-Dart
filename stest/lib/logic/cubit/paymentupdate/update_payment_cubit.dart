import 'package:bloc/bloc.dart';
import 'package:stest/data/models/transactions/ledger_log.dart';

import 'package:stest/data/repositories/ledger_repository/ledger_repository.dart';
import 'package:stest/data/repositories/transaction_repository/due_repository.dart';
import 'package:stest/data/repositories/transaction_repository/ledger_log_repository.dart';

import '../../../data/models/ledgermodel/ledger.dart';

part 'update_payment_state.dart';

class UpdatePaymentCubit extends Cubit<UpdatePaymentState> {
  final _ledgerRepository = LedgerRepository();
  UpdatePaymentCubit() : super(UpdatePaymentState());
  void valueChange(String value) {
    try {
      emit(state.copyWith(int.tryParse(value)));
    } catch (e) {
      emit(UpdatePaymentFailedState(msg: e.toString()));
    }
  }

  void savePayment({required int value, required Ledger ledger}) async {
    try {
      state.copyWith(value);
      emit(UpdatePaymentInitalState());
      int updatedValue = ledger.currentValue + value;
      await _ledgerRepository.updatePayment(
          value: updatedValue, ledgerId: ledger.id);
      //creating a log for the ledger
      await LedgerLogRepository().addLedgerLog(
          log: LedgerLog(
              ledgerId: ledger.id, date: DateTime.now(), value: value));
      await DueRepository().updateDue(
          doIncrease: false,
          from: ledger.creatorId,
          to: ledger.assignedId,
          value: value);

      await LedgerRepository().updateStatus(ledgerId: ledger.id);

      emit(UpdatePaymentSuccessState(msg: 'payment updated successfully'));
    } catch (e) {
      emit(UpdatePaymentFailedState(msg: e.toString()));
    }
  }
}
