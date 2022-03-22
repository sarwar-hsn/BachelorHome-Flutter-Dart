import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stest/data/models/ledgermodel/ledger.dart';
import 'package:stest/data/repositories/auth_repository/authentication_repository.dart';
import 'package:stest/data/repositories/ledger_repository/request_ledger_repository.dart';
import 'package:stest/logic/bloc/LedgerRequest/ledger_request_bloc.dart';
import 'package:stest/logic/bloc/appbloc/app_bloc.dart';
import 'package:stest/logic/bloc/appbloc/app_state.dart';
import 'package:stest/others/constants.dart';
import 'package:stest/presentation/screens/create_ledger_screen.dart';
import 'package:stest/presentation/screens/homepage_screen.dart';
import 'package:stest/presentation/screens/ledger_details_screen.dart';
import 'package:stest/presentation/screens/ledger_log_screen.dart';
import 'package:stest/presentation/screens/login_screen.dart';
import 'package:stest/presentation/screens/peding_ledger_screen.dart';
import 'package:stest/presentation/screens/profile_screen.dart';
import 'package:stest/presentation/screens/reset_password.dart';

import '../logic/cubit/login/login_cubit.dart';
import '../logic/cubit/passreset/passreset_cubit.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => const AuthenticationWrapper(),
        );
      case Constants.profileRoute:
        return MaterialPageRoute(builder: (context) => const ProfileScreen());
      case Constants.requestLedger:
        return MaterialPageRoute(builder: (_) => CreateLedgerScreen());
      case '/resetpassword':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => PassresetCubit(
                      AuthenticationRepository(FirebaseAuth.instance)),
                  child: ResetPasswordScreen(),
                ));
      case Constants.pendingLedgers:
        return MaterialPageRoute(builder: (_) => const PendingLedgersScreen());
      case Constants.ledgerLog:
        return MaterialPageRoute(builder: (_) => const LedgerLogScreen());
      case '/ledgerdetails':
        final args = settings.arguments as Ledger;
        return MaterialPageRoute(
          builder: (_) => LedgerDetailsScreen(ledger: args),
        );
      default:
        return null;
    }
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        switch (state.status) {
          case AppStatus.authenticated:
            return BlocProvider(
              create: (context) => LedgerRequestBloc(
                  requestedLedgerRepository: RequestedLedgerRepository()),
              child: HomepageScreen(
                title: 'bachelor point'.toUpperCase(),
              ),
            );
          case AppStatus.unauthenticated:
          default:
            return BlocProvider(
              create: (context) =>
                  LoginCubit(AuthenticationRepository(FirebaseAuth.instance)),
              child: LoginScreen(),
            );
        }
      },
    );
  }
}
