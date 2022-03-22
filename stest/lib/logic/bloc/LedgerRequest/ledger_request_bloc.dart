import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:stest/others/constants.dart';

import '../../../data/models/ledgermodel/ledger.dart';
import '../../../data/models/ledgermodel/ledger_entity.dart';
import '../../../data/repositories/ledger_repository/request_ledger_repository.dart';
import '../../../data/repositories/userrepo/user_repository.dart';
part 'ledger_request_event.dart';
part 'ledger_request_state.dart';

class LedgerRequestBloc extends Bloc<LedgerRequestEvent, LedgerRequestState> {
  final RequestedLedgerRepository requestedLedgerRepository;
  late final UserRepository _userRepository = UserRepository();
  late final StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>
      _pendingLedgerSubscription;
  //constructor with repository initialized
  LedgerRequestBloc({required this.requestedLedgerRepository})
      : super(const LedgerRequestState()) {
    //listening to pendingledger event
    _pendingLedgerSubscription = _userRepository
        .pendingLedgers(
      userId: Constants.user!.id,
    )
        .listen(
      (snap) async {
        final listOfLedger = await requestedLedgerRepository
            .pendingLedgers([...(snap.data() as dynamic)['pendingLedger']]);
        add(GetPendingLedgersEvent(ledgers: listOfLedger));
      },
    );

    //on name change event
    on<NameChangeEvent>(
      (event, emit) {
        emit(state.copyWith(name: event.name));
      },
    );

    on<UserChangeEvent>(
      (event, emit) {
        emit(state.copyWith(assignedId: event.assignedId));
      },
    );

    on<DateChangeEvent>(
      (event, emit) {
        emit(state.copyWith(date: event.date));
      },
    );

    on<ValueChangeEvent>(
      (event, emit) {
        if (int.tryParse(event.value) != null) {
          emit(state.copyWith(value: int.parse(event.value)));
        }
      },
    );

    on<AddToRequestedLedgerEvent>(
      (event, emit) async {
        emit(RequestLedgerInitialState());
        state.copyWith(
            name: event.ledger.name,
            value: event.ledger.value,
            date: event.ledger.date,
            assignedId: event.ledger.assignedId);
        try {
          final _docRef =
              await requestedLedgerRepository.addLedger(event.ledger);
          final snapshot = await _docRef.get();
          final _ledgerEntity = LedgerEntity.fromSnapShot(snapshot);
          await _userRepository.addToPending(
              event.ledger.assignedId, _ledgerEntity.id);
          await _userRepository.addToCreatedLedger(
              currentUserId: event.ledger.creatorId,
              ledgerId: _ledgerEntity.id);
          emit(const RequestLedgerSuccessState(
              msg: 'ledger requested successfully'));
        } catch (e) {
          emit(RequestLedgerFailedState(msg: e.toString()));
        }
      },
    );

    on<GetPendingLedgersEvent>(
      (event, emit) {
        emit(PendingLedgerInitState());
        try {
          emit(PendingLedgerSuccessState(
              ledgers: (event.ledgers.isNotEmpty) ? event.ledgers : []));
        } catch (e) {
          emit(PendingLedgerFailedState(msg: e.toString()));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _pendingLedgerSubscription.cancel();
    return super.close();
  }
}
