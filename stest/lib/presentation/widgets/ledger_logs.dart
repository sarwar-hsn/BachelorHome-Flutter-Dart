import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../logic/cubit/ledgerlogcubit/ledger_log_cubit.dart';

class LedgerLogs extends StatelessWidget {
  const LedgerLogs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LedgerLogCubit, LedgerLogState>(
      builder: (context, state) {
        if (state is LedgerLogInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is LedgerLogFailedState) {
          return const Center(
            child: Text('failed to load logs'),
          );
        } else if (state is LedgerLogSuccessState) {
          if (state.logs.isEmpty) {
            return const Text('log is empty');
          } else {
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20),
              child: ListView.builder(
                  itemCount: state.logs.length,
                  itemBuilder: (context, index) {
                    return Text(DateFormat('EEE, MMM d, ' 'yyyy')
                            .format(state.logs[index].date) +
                        '    value :' +
                        state.logs[index].value.toString());
                  }),
            );
          }
        }
        return Text(state.toString());
      },
    );
  }
}
