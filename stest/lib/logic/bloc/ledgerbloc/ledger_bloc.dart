import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stest/data/models/ledgermodel/ledger_entity.dart';
import 'package:stest/data/repositories/userrepo/user_repository.dart';
import 'package:stest/logic/bloc/ledgerbloc/ledger_event.dart';
import 'package:stest/logic/bloc/ledgerbloc/ledger_state.dart';

import '../../../data/models/ledgermodel/ledger.dart';
import '../../../data/repositories/ledger_repository/ledger_repository.dart';

class LedgerBloc extends Bloc<LedgerEvent, LedgerState> {
  late final UserRepository _userRepository = UserRepository();
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _activeLedgerSubscription;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _ledgerById;
  LedgerRepository ledgerRepository;
  LedgerBloc({required this.ledgerRepository}) : super(LedgerInitialState()) {
    on<ApproveLedgerState>(
      (event, emit) async {
        emit(ApproveLedgerInitiateState());
        try {
          final _docRef = await ledgerRepository.addLedger(event.ledger);
          final snapshot = await _docRef.get();
          final _ledgerEntity = LedgerEntity.fromSnapShot(snapshot);
          await _userRepository.addToAssignedLedger(
              assignedToUserId: event.ledger.assignedId,
              ledgerId: _ledgerEntity.id);

          //here will be the delete from pending slot
          //delete from requested ledger to approved ledger
          emit(ApproveLedgerSuccessState(
              msg: 'ledger approved and added successfully'));
        } catch (e) {
          emit(ApproveLedgerFailedState(msg: e.toString()));
        }
      },
    );

    on<GetLedgerDateEvent>(
      (event, emit) {},
    );
    on<GetLedgerByActiveStatusEvent>(
      (event, emit) {},
    );
    on<GetAllLedgerEvent>(
      (event, emit) {
        try {
          _activeLedgerSubscription ??=
              ledgerRepository.ledgers().listen(_snaps);
        } catch (e) {
          rethrow;
        }
      },
    );
    on<SendActiveLedgersEvent>(
      (event, emit) {
        try {
          emit(GetAllLedgerInitState());
          emit(GetAllLedgerSuccessState(ledgers: event.activeLedgers));
        } catch (e) {
          emit(GetAllLedgerFailedState(msg: e.toString()));
        }
      },
    );
    on<GetLedgerByIdEvent>(
      (event, emit) {
        try {
          _ledgerById ??= ledgerRepository
              .getLedgerById(ledgerId: event.ledgerid)
              .listen(_ledgerid);
        } catch (e) {
          rethrow;
        }
      },
    );
    on<SendLedgerFromIdEvent>(
      (event, emit) {
        emit(GetLedgerByIdInitState());
        try {
          emit(GetLedgerByIdSuccessState(ledger: event.ledger));
        } catch (e) {
          emit(GetLedgerByIdFailedState(msg: e.toString()));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _activeLedgerSubscription?.cancel();
    _ledgerById?.cancel();
    return super.close();
  }

  void _snaps(QuerySnapshot<Map<String, dynamic>> querySnapshot) async {
    List<Ledger> activeLedgers = [];
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      activeLedgers.add(Ledger.fromLedgerEntity(
          LedgerEntity.fromQuery(querySnapshot.docs[i])));
    }
    add(SendActiveLedgersEvent(activeLedgers: [...activeLedgers]));
  }

  void _ledgerid(DocumentSnapshot<Map<String, dynamic>> snap) {
    Ledger ledger = Ledger.fromLedgerEntity(LedgerEntity.fromSnapShot(snap));
    add(SendLedgerFromIdEvent(ledger: ledger));
  }
}
