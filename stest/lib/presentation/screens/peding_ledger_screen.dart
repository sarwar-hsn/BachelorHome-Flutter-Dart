import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stest/data/repositories/ledger_repository/request_ledger_repository.dart';
import 'package:stest/data/repositories/userrepo/user_repository.dart';
import 'package:stest/logic/bloc/LedgerRequest/ledger_request_bloc.dart';
import 'package:stest/logic/bloc/userbloc/user_bloc.dart';
import 'package:stest/presentation/widgets/ledger_tile.dart';

class PendingLedgersScreen extends StatelessWidget {
  const PendingLedgersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LedgerRequestBloc(
              requestedLedgerRepository: RequestedLedgerRepository()),
        ),
        BlocProvider(
          create: (context) => UserBloc(userRepository: UserRepository()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('pending ledgers'),
        ),
        body: Center(
          child: BlocBuilder<LedgerRequestBloc, LedgerRequestState>(
            builder: (context, state) {
              if (state is PendingLedgerInitState) {
                return const CircularProgressIndicator();
              } else if (state is PendingLedgerSuccessState) {
                if (state.ledgers.isEmpty) {
                  return const Text('you have no pending ledger');
                }
                return ListView.builder(
                    itemCount: state.ledgers.length,
                    itemBuilder: (context, index) {
                      return LedgerTile(ledger: state.ledgers[index]);
                    });
              } else if (state is PendingLedgerFailedState) {
                return const Text('something went wront');
              }
              return const Text('peding ledgers');
            },
          ),
        ),
      ),
    );
  }
}
