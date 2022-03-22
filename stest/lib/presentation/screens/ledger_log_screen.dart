import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stest/data/repositories/userrepo/user_repository.dart';
import 'package:stest/logic/bloc/userbloc/user_bloc.dart';
import 'package:stest/logic/cubit/ledgerdate/ledger_date_cubit.dart';
import 'package:stest/presentation/widgets/active_ledgers.dart';
import '../../logic/bloc/userbloc/user_event.dart';

class LedgerLogScreen extends StatelessWidget {
  const LedgerLogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _bloc = BlocProvider(create: (context) => LedgerDateCubit());
    return MultiBlocProvider(
      providers: [
        _bloc,
        BlocProvider(
            create: (context) => UserBloc(userRepository: UserRepository())
              ..add(GetAllUserEvent()))
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('logs'),
          actions: [
            BlocBuilder<LedgerDateCubit, LedgerDateState>(
              builder: (context, state) {
                return IconButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2019),
                        lastDate: DateTime(2025),
                      );
                      if (pickedDate != null) {
                        final _bloc = BlocProvider.of<LedgerDateCubit>(context);

                        int month =
                            int.parse(DateFormat('M').format(pickedDate));
                        int year =
                            int.parse(DateFormat('y').format(pickedDate));
                        state.copyWith(month, year);
                        _bloc.getLedgers(month, year);
                      }
                    },
                    icon: const Icon(Icons.date_range));
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Center(
              child: BlocBuilder<LedgerDateCubit, LedgerDateState>(
                builder: (context, state) {
                  if (state is GetLedgersSuccessState) {
                    return Text('ledgers of ' +
                        DateFormat.MMMM()
                            .format(DateTime(0, state.pickedMonth)) +
                        ', ' +
                        state.pickedYear.toString());
                  }
                  return const Text('ledgers');
                },
              ),
            ),
            _ledgersList()
          ],
        ),
      ),
    );
  }

  Expanded _ledgersList() {
    return Expanded(
      child: BlocBuilder<LedgerDateCubit, LedgerDateState>(
        builder: (context, state) {
          if (state is GetLedgersFailedState) {
            return const Center(
              child: Text('failed to retrive ledgers'),
            );
          } else if (state is GetLedgersSuccessState) {
            if (state.ledgers.isEmpty) {
              return const Center(
                child: Text('no active ledgers found'),
              );
            }
            return ActiveLedgers(
              ledgers: state.ledgers,
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
