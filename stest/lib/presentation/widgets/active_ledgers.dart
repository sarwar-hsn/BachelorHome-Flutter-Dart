import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../data/models/ledgermodel/ledger.dart';
import '../../logic/bloc/userbloc/user_bloc.dart';
import '../../logic/bloc/userbloc/user_state.dart';

class ActiveLedgers extends StatelessWidget {
  final List<Ledger> ledgers;
  const ActiveLedgers({
    Key? key,
    required this.ledgers,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: ledgers.length,
        itemBuilder: (context, index) {
          return Center(
            heightFactor: 1.3,
            child: _acitveLedgerTile(context, ledgers[index]),
          );
        });
  }
}

_acitveLedgerTile(context, Ledger ledger) {
  return InkWell(
    child: ListTile(
      onTap: () {
        Navigator.of(context).pushNamed('/ledgerdetails', arguments: ledger);
      },
      leading: CircleAvatar(
        maxRadius: 25,
        backgroundColor: Colors.green,
        child: FittedBox(
            alignment: Alignment.center,
            child: Column(
              children: [Text(ledger.value.toString()), const Text('tl')],
            )),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${ledger.name}  (${DateFormat('d/M/y').format(ledger.date)})'),
        ],
      ),
      subtitle: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is AllUserState) {
            final _creator = state.getUserById(ledger.creatorId);
            final _assgined = state.getUserById(ledger.assignedId);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('creator: ' + _creator!.name.toString()),
                Text('assigned to: ' + _assgined!.name.toString()),
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
  );
}
