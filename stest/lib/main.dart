import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stest/data/repositories/auth_repository/authentication_repository.dart';
import 'package:stest/logic/bloc/appbloc/app_bloc.dart';

import 'package:stest/presentation/router.dart';
import 'package:firebase_core/firebase_core.dart';

import 'others/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MyApp(
      router: AppRouter(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppRouter router;
  const MyApp({Key? key, required this.router}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppBloc(
              authenticationRepository:
                  AuthenticationRepository(FirebaseAuth.instance)),
        ),
      ],
      child: MaterialApp(
        title: 'home',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              centerTitle: true,
              backgroundColor: Color.fromARGB(255, 77, 71, 53)),
          scaffoldBackgroundColor: const Color.fromARGB(255, 7, 9, 32),
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: const Color.fromARGB(255, 114, 105, 104),
                displayColor: const Color.fromARGB(255, 113, 106, 117),
              ),
          primaryColor: Colors.amberAccent,
          primaryColorLight: const Color.fromARGB(255, 116, 52, 15),
          progressIndicatorTheme: const ProgressIndicatorThemeData(
              circularTrackColor: Colors.deepPurple),
          inputDecorationTheme: const InputDecorationTheme(
              fillColor: Color.fromRGBO(227, 242, 253, 1),
              filled: true,
              focusedErrorBorder: Constants.errorBorder,
              focusedBorder: Constants.focusBorder,
              enabledBorder: Constants.enabledBorder,
              errorBorder: Constants.errorBorder),
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: router.generateRoute,
      ),
    );
  }
}
