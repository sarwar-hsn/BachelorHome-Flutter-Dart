import 'package:bloc/bloc.dart';

import 'package:stest/data/repositories/ledger_repository/declined_repository.dart';
import 'package:stest/data/repositories/ledger_repository/ledger_repository.dart';
import 'package:stest/data/repositories/transaction_repository/due_repository.dart';
import 'package:stest/data/repositories/userrepo/user_repository.dart';
import 'package:stest/logic/bloc/userbloc/user_event.dart';
import 'package:stest/logic/bloc/userbloc/user_state.dart';
import '../../../data/models/ledgermodel/ledger.dart';
import '../../../data/repositories/ledger_repository/request_ledger_repository.dart';
import '../../../others/constants.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;
  UserBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(UserInitialState()) {
    on<GetUserEvent>((event, emit) async {
      await for (final users in _userRepository.users()) {
        for (int i = 0; i < users.length; i++) {
          if (users[i].id == Constants.user?.id) {
            emit(UserFoundState(foundedUser: users[i]));
            return;
          }
          emit(NoUserState(msg: 'user not found'));
        }
      }
    });

    on<GetAllUserEvent>(
      (event, emit) async {
        emit(UserInitialState());
        try {
          await for (final users in _userRepository.users()) {
            emit(AllUserState(users: [...users]));
          }
        } catch (e) {
          emit(NoUserState(msg: e.toString()));
        }
      },
    );

    on<AcceptingLedgerEvent>(
      (event, emit) async {
        emit(AcceptLedgerInitState());
        try {
          await _userRepository.deleteFromPending(event.userId, event.ledgerId);
          await _userRepository.addToAssignedLedger(
              assignedToUserId: event.userId, ledgerId: event.ledgerId);
          Ledger ledger = await RequestedLedgerRepository()
              .removeLedger(ledgerId: event.ledgerId);
          await LedgerRepository().addLedger(ledger);
          await DueRepository().updateDue(
              from: ledger.creatorId,
              to: ledger.assignedId,
              value: ledger.value,
              doIncrease: true);
          emit(AcceptLedgerSuccessState(msg: 'ledger accepted'));
        } catch (e) {
          emit(AcceptLedgerFailedState(msg: 'failed to accept'));
        }
      },
    );

    on<RejectingLedgerEvent>(
      (event, emit) async {
        await _userRepository.deleteFromPending(
            event.userId, event.ledgerId); //removing from pending
        await _userRepository.addToDeclined(
            event.userId, event.ledgerId); //addding to user declined
        Ledger ledger = await RequestedLedgerRepository()
            .removeLedger(ledgerId: event.ledgerId);
        await DeclinedLedgerRepository().addLedger(ledger);
      },
    );
  }
}
