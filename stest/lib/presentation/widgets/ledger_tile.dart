import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stest/data/models/ledgermodel/ledger.dart';
import 'package:stest/logic/bloc/userbloc/user_bloc.dart';

import '../../logic/bloc/userbloc/user_event.dart';
import '../../logic/bloc/userbloc/user_state.dart';

class LedgerTile extends StatelessWidget {
  final Ledger ledger;
  const LedgerTile({Key? key, required this.ledger}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.amber),
      height: 150,
      child: Card(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(ledger.name),
                  Text(ledger.assignedId),
                  Text(ledger.creatorId),
                  _acceptButton(context, ledger.assignedId, ledger.id)
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(ledger.value.toString()),
                  Text(ledger.date.toIso8601String()),
                  Text(ledger.isActive.toString()),
                  _rejectButton(context,
                      ledgerId: ledger.id, userId: ledger.assignedId)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _acceptButton(context, String userId, String ledgerId) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is AcceptLedgerInitState) {
          return const CircularProgressIndicator();
        } else if (state is AcceptLedgerFailedState) {
          return const Text('failed to accept');
        }
        return OutlinedButton(
            onPressed: () {
              BlocProvider.of<UserBloc>(context).add(
                  AcceptingLedgerEvent(ledgerId: ledgerId, userId: userId));
            },
            child: const Text('accept'));
      },
    );
  }

  Widget _rejectButton(context,
      {required String userId, required String ledgerId}) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is RejectingLedgerInitState) {
          return const CircularProgressIndicator();
        } else if (state is RejectingLedgerFailedState) {
          return const Text('failed...try again');
        }
        return OutlinedButton(
            onPressed: () {
              BlocProvider.of<UserBloc>(context).add(
                  RejectingLedgerEvent(ledgerId: ledgerId, userId: userId));
            },
            child: const Text('reject'));
      },
    );
  }
}
