import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stest/data/models/ledgermodel/ledger.dart';
import 'package:stest/data/repositories/ledger_repository/ledger_repository.dart';
import 'package:stest/data/repositories/userrepo/user_repository.dart';
import 'package:stest/logic/bloc/ledgerbloc/ledger_bloc.dart';
import 'package:stest/logic/bloc/userbloc/user_bloc.dart';
import 'package:stest/logic/cubit/ledgerlogcubit/ledger_log_cubit.dart';
import 'package:stest/presentation/widgets/ledger_logs.dart';

import '../../data/models/usermodels/user.dart';
import '../../logic/bloc/ledgerbloc/ledger_event.dart';
import '../../logic/bloc/ledgerbloc/ledger_state.dart';
import '../../logic/bloc/userbloc/user_event.dart';
import '../../logic/bloc/userbloc/user_state.dart';
import '../../logic/cubit/paymentupdate/update_payment_cubit.dart';

class LedgerDetailsScreen extends StatelessWidget {
  final Ledger ledger;

  final _formKey = GlobalKey<FormState>();
  LedgerDetailsScreen({Key? key, required this.ledger}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UpdatePaymentCubit(),
        ),
        BlocProvider(
            create: (context) =>
                LedgerBloc(ledgerRepository: LedgerRepository())
                  ..add(GetLedgerByIdEvent(ledgerid: ledger.id))),
        BlocProvider(create: (context) => LedgerLogCubit(ledgerId: ledger.id)),
        BlocProvider(
            create: (context) => UserBloc(userRepository: UserRepository())
              ..add(GetAllUserEvent())),
      ],
      child: BlocBuilder<LedgerBloc, LedgerState>(
        builder: (context, state) {
          if (state is GetLedgerByIdSuccessState) {
            BlocProvider.of<LedgerLogCubit>(context);
          }
          return Scaffold(
              appBar: _appbar(),
              body: (state is GetLedgerByIdInitState)
                  ? _progressindicator()
                  : (state is GetLedgerByIdSuccessState)
                      ? LayoutBuilder(builder: (context, constraint) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  _leftCard(state.ledger),
                                  _rightCard(state.ledger)
                                ],
                              ),
                              (ledger.isActive)
                                  ? _paymentCard(context, state.ledger)
                                  : const Text(''),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Ledger Logs',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Expanded(
                                child: LedgerLogs(),
                              )
                            ],
                          );
                        })
                      : const Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }

  Widget _paymentCard(context, Ledger ledger) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(5),
        height: 130,
        width: double.infinity,
        child: Card(
          color: const Color.fromARGB(255, 105, 105, 106),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('payment box'),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                      flex: 2,
                      child: _updatePaymentTextField(context, ledger: ledger)),
                  Expanded(flex: 1, child: _updateButton(ledger)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _updateButton(Ledger ledger) {
    return BlocConsumer<UpdatePaymentCubit, UpdatePaymentState>(
      listener: (context, state) {
        if (state is UpdatePaymentSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.msg),
            backgroundColor: Colors.lightGreen,
          ));
        } else if (state is UpdatePaymentFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.msg),
            backgroundColor: Colors.redAccent,
          ));
        }
      },
      builder: (context, state) {
        if (state is UpdatePaymentInitalState) {
          return _progressindicator();
        }
        return Container(
            padding: const EdgeInsets.only(right: 10, left: 5, bottom: 0),
            child: OutlinedButton(
                onPressed: () {
                  final isValid = _formKey.currentState?.validate();
                  if (isValid != null && isValid == true) {
                    BlocProvider.of<UpdatePaymentCubit>(context)
                        .savePayment(value: state.value, ledger: ledger);
                    _formKey.currentState?.reset();
                  }
                },
                child: const Text('update')));
      },
    );
  }

  Center _progressindicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  AppBar _appbar() {
    return AppBar(
      title: const Text('ledger details'),
    );
  }

  Widget _updatePaymentTextField(context, {required Ledger ledger}) {
    return BlocBuilder<UpdatePaymentCubit, UpdatePaymentState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.only(right: 5, left: 5),
          width: 200,
          child: TextFormField(
            validator: (value) {
              return state.validatePayment(value, ledger: ledger);
            },
            onChanged: (value) {
              BlocProvider.of<UpdatePaymentCubit>(context).valueChange(value);
            },
            decoration: InputDecoration(
              hintText: 'due : ${ledger.value - ledger.currentValue}',
              contentPadding: const EdgeInsets.only(bottom: 5, left: 10),
            ),
            keyboardType: TextInputType.number,
          ),
        );
      },
    );
  }

  Widget _leftCard(Ledger ledger) {
    return Expanded(
      child: SizedBox(
        height: 200,
        child: Card(
          child: ListTile(
            title: Text(ledger.name.toUpperCase() + "\n"),
            subtitle: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is AllUserState) {
                  User? _creator = state.getUserById(ledger.creatorId);
                  User? _assigned = state.getUserById(ledger.assignedId);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('created by:\t' + _creator!.name.toString() + "\n"),
                      Text('assigned to:' + _assigned!.name.toString()),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('creator: ' + ledger.creatorId),
                    Text('assigned to: ' + ledger.assignedId),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _rightCard(Ledger ledger) {
    return Expanded(
      child: SizedBox(
        height: 200,
        child: Card(
          child: ListTile(
            title: Text(
              'created on : \n' +
                  DateFormat.yMMMMd().format(ledger.date) +
                  "\n",
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('value : ' + ledger.value.toString() + "\n"),
                Text('paid   : ' + ledger.currentValue.toString() + "\n"),
                Text((ledger.isActive)
                    ? 'active ledger'
                    : 'ledger value fulfilled')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
