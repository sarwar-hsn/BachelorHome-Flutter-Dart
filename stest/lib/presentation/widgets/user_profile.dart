import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stest/logic/cubit/dues/dues_cubit.dart';

import '../../data/repositories/userrepo/user_repository.dart';

import '../../logic/bloc/userbloc/user_bloc.dart';
import '../../logic/bloc/userbloc/user_event.dart';
import '../../logic/bloc/userbloc/user_state.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            UserBloc(userRepository: UserRepository())..add(GetUserEvent()),
        child: Container(
          width: double.infinity,
          height: 250,
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 188, 187, 190),
                Color.fromARGB(255, 188, 187, 189),
              ]),
            ),
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 10,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        const CircleAvatar(
                            radius: 50, child: Icon(Icons.person)),
                        const SizedBox(
                          height: 10,
                        ),
                        BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                            if (state is NoUserState) {
                              return Text(state.msg);
                            } else if (state is UserFoundState) {
                              return Text(
                                'welcome ' + state.foundedUser.name.toString(),
                                style: Theme.of(context).textTheme.titleLarge,
                              );
                            }
                            return const CircularProgressIndicator();
                          },
                        ),
                        _status(context)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _statusCard() {
    return Expanded(
      child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          color: const Color.fromARGB(255, 214, 213, 216),
          child: SizedBox(
            height: 60,
            child: Center(
              child: BlocBuilder<DuesCubit, DuesState>(
                builder: (context, state) {
                  if (state is DuesFailedState) {
                    return const Text('you are a failure');
                  } else if (state is DuesSuccessState) {
                    int sum = 0;
                    for (var element in state.dues) {
                      sum += element.due;
                    }
                    if (sum < 100 && sum > 50) {
                      return const Text('not broke yet');
                    } else if (sum <= 50) {
                      return const Text('as of now you are rich');
                    } else if (sum >= 100 && sum <= 150) {
                      return const Text(
                          'not broke yet but pay before you become one');
                    } else if (sum > 150) {
                      return const Text('you broke ass nigga');
                    }
                  } else if (state is DuesInitial) {
                    return const CircularProgressIndicator();
                  }
                  return const Text('your account is hiding in your ass');
                },
              ),
            ),
          )),
    );
  }

  Widget _status(context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 50, left: 5, right: 5),
      child: Flex(
        direction: Axis.horizontal,
        children: [_statusCard()],
      ),
    );
  }
}
