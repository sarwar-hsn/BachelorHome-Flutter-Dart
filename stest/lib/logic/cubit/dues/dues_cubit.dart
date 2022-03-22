import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:stest/data/models/transactions/due_insight.dart';

import '../../../data/repositories/transaction_repository/due_repository.dart';

part 'dues_state.dart';

class DuesCubit extends Cubit<DuesState> {
  DuesCubit() : super(DuesInitial());

  void getDues() async {
    try {
      final dues = await DueRepository().getDue();

      emit(DuesSuccessState(dues: dues));
    } catch (e) {
      emit(DuesFailedState(msg: e.toString()));
    }
  }
}
