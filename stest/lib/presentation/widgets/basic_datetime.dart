import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../logic/bloc/LedgerRequest/ledger_request_bloc.dart';

class BasicDateField extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd");

  BasicDateField({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      DateTimeField(
        initialValue: DateTime.now(),
        decoration: const InputDecoration(
          hintText: 'pick a date',
          labelText: 'ledger creation date',
        ),
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(2021),
              initialDate: DateTime.now(),
              lastDate: DateTime(2023));
        },
        onChanged: (value) {
          if (value != null) {
            BlocProvider.of<LedgerRequestBloc>(context)
                .add(DateChangeEvent(date: value));
          }
        },
        validator: (value) {
          if (value == null) {
            return 'empty field';
          }
          return null;
        },
      ),
    ]);
  }
}
