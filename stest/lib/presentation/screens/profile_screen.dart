import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stest/data/repositories/userrepo/user_repository.dart';
import 'package:stest/logic/bloc/userbloc/user_bloc.dart';
import 'package:stest/logic/cubit/dues/dues_cubit.dart';
import 'package:stest/presentation/widgets/user_profile.dart';

import '../../data/models/transactions/due_insight.dart';

import '../../logic/bloc/userbloc/user_event.dart';
import '../../logic/bloc/userbloc/user_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => UserBloc(userRepository: UserRepository())
              ..add(GetAllUserEvent())),
        BlocProvider(create: (context) => DuesCubit()..getDues()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('profile'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [const UserProfile(), _dueCard()],
          ),
        ),
      ),
    );
  }

  Widget _dueCard() {
    return BlocBuilder<DuesCubit, DuesState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.only(top: 50, left: 10, right: 10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 188, 187, 190),
              Color.fromARGB(255, 188, 187, 189),
            ]),
          ),
          padding: const EdgeInsets.all(10),
          height: 250,
          width: double.infinity,
          child: (state is DuesInitial)
              ? const Center(child: CircularProgressIndicator())
              : (state is DuesFailedState)
                  ? const Center(
                      child: Text(
                        'failed to retrive dues',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : (state is DuesSuccessState)
                      ? _listTile(state.dues)
                      : const Text(
                          'dues log',
                          style: TextStyle(color: Colors.white70),
                        ),
        );
      },
    );
  }

  Widget _listTile(List<Due> dues) {
    return ListView.builder(
        itemCount: dues.length + 1,
        itemBuilder: (context, index) {
          if (index == dues.length) {
            int sum = 0;
            for (var element in dues) {
              sum += element.due;
            }
            return ListTile(
              title: Text(
                'Total Due: $sum',
              ),
            );
          }
          return _dueTile(dues, index);
        });
  }

  Widget _dueTile(List<Due> dues, int index) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is AllUserState) {
          return ListTile(
            title: Text(
              'to ${state.getUserById(dues[index].to)?.name}',
            ),
            subtitle: Text(
              'Due Amount: ${dues[index].due} tl',
            ),
          );
        }
        return const Text('....');
      },
    );
  }
}
