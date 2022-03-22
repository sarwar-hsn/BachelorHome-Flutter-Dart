import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/bloc/ledgerbloc/ledger_bloc.dart';
import '../../logic/bloc/ledgerbloc/ledger_state.dart';

class LedgerList extends StatelessWidget {
  const LedgerList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LedgerBloc, LedgerState>(
      builder: (context, state) {
        if (state is GetAllLedgerInitState) {
          return const CircularProgressIndicator();
        } else if (state is GetAllLedgerSuccessState) {
          return ListView.builder(
            itemCount: state.ledgers.length,
            itemBuilder: (context, index) {
              return Center(
                  child: Text("name: " +
                      state.ledgers[index].name +
                      " value: " +
                      state.ledgers[index].value.toString() +
                      " ${(state.ledgers[index].isActive) ? 'active' : 'not active'}"));
            },
          );
        } else if (state is GetAllLedgerFailedState) {
          return const Text('trying to retrive ledgers...');
        }
        return const Center(
          child: Text('ledgers'),
        );
      },
    );
  }
}
