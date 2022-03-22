import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stest/data/models/ledgermodel/ledger.dart';
import 'package:stest/data/models/usermodels/user.dart';
import 'package:stest/data/repositories/ledger_repository/request_ledger_repository.dart';
import 'package:stest/data/repositories/userrepo/user_repository.dart';
import 'package:stest/logic/bloc/LedgerRequest/ledger_request_bloc.dart';
import 'package:stest/logic/bloc/appbloc/app_bloc.dart';
import 'package:stest/logic/bloc/userbloc/user_bloc.dart';
import 'package:stest/others/constants.dart';
import 'package:stest/presentation/widgets/basic_datetime.dart';
import '../../logic/bloc/userbloc/user_event.dart';
import '../../logic/bloc/userbloc/user_state.dart';

class CreateLedgerScreen extends StatelessWidget {
  CreateLedgerScreen({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  get created => null;
  @override
  Widget build(BuildContext context) {
    final _id = context.select((AppBloc bloc) => bloc.state.user).id;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => LedgerRequestBloc(
                requestedLedgerRepository: RequestedLedgerRepository())),
        BlocProvider(
            create: (context) => UserBloc(userRepository: UserRepository())
              ..add(GetAllUserEvent()))
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("create ledger"),
        ),
        body: Center(
            child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                textFieldName('name', context),
                textFieldValue('value', context),
                _assignTo(currentUserId: _id),
                _dateTime(),
                submitButton(btnText: 'create ledger'.toUpperCase(), id: _id),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget submitButton({required String btnText, required String id}) {
    return BlocConsumer<LedgerRequestBloc, LedgerRequestState>(
      listener: (context, state) {
        if (state is RequestLedgerSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.msg),
            backgroundColor: Colors.lightGreen,
          ));
          _formKey.currentState?.reset();
        } else if (state is RequestLedgerFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.msg),
            backgroundColor: Colors.redAccent,
          ));
        }
      },
      builder: (context, state) {
        return OutlinedButton(
            onPressed: () {
              final isValid = _formKey.currentState?.validate();
              if (isValid == true &&
                  state.assignedId != null &&
                  Constants.user != null) {
                BlocProvider.of<LedgerRequestBloc>(context)
                    .add(AddToRequestedLedgerEvent(
                        ledger: Ledger(
                  name: state.name,
                  assignedId: state.assignedId!,
                  date: state.date ?? DateTime.now(),
                  creatorId: Constants.user!.id,
                  id: '',
                  isActive: true,
                  value: state.value,
                  currentValue: 0,
                )));
              }
            },
            child: (state is RequestLedgerInitialState)
                ? const CircularProgressIndicator()
                : Text(btnText));
      },
    );
  }

  Widget textFieldName(String title, context) {
    return BlocBuilder<LedgerRequestBloc, LedgerRequestState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: TextFormField(
            validator: ((value) {
              return state.nameValidate(value!);
            }),
            onChanged: (value) {
              BlocProvider.of<LedgerRequestBloc>(context)
                  .add(NameChangeEvent(name: value));
            },
            decoration: InputDecoration(
              labelText: title,
            ),
          ),
        );
      },
    );
  }

  Widget textFieldValue(String title, context) {
    return BlocBuilder<LedgerRequestBloc, LedgerRequestState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: TextFormField(
            keyboardType: TextInputType.number,
            validator: (value) {
              return state.valueValidate(value!);
            },
            onChanged: (value) {
              BlocProvider.of<LedgerRequestBloc>(context)
                  .add(ValueChangeEvent(value: value));
            },
            decoration: InputDecoration(
              labelText: title,
            ),
          ),
        );
      },
    );
  }

  Widget _dateTime() {
    return BlocBuilder<LedgerRequestBloc, LedgerRequestState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: BasicDateField(),
        );
      },
    );
  }

  Widget _assignTo({required String currentUserId}) {
    List<User> _users = [];
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is AllUserState && _users.isEmpty) {
          _users = [...state.users];
        }
        return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: DropdownButtonFormField<User>(
              decoration: const InputDecoration(),
              hint: (state is NoUserState)
                  ? const Text('failed to retrive user...')
                  : const Text('assign to '),
              onChanged: ((value) {
                BlocProvider.of<LedgerRequestBloc>(context)
                    .add(UserChangeEvent(assignedId: (value as User).id));
              }),
              validator: (user) {
                if (user != null) {
                  return null;
                } else {
                  return 'assigned user not selected';
                }
              },
              items: (_users.isNotEmpty)
                  ? _users
                      .map(
                        (user) => DropdownMenuItem(
                          child: Text(user.name.toString()),
                          value: user,
                        ),
                      )
                      .toList()
                  : null,
            ));
      },
    );
  }
}
