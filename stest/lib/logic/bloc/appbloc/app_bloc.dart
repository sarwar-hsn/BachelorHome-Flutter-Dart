import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:stest/logic/bloc/appbloc/app_event.dart';
import 'package:stest/logic/bloc/appbloc/app_state.dart';

import '../../../data/models/usermodels/user.dart';
import '../../../data/repositories/auth_repository/authentication_repository.dart';
import '../../../others/constants.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<User> _userSubscription;
  AppBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(
          const AppState.unauthenticated(),
        ) {
    _userSubscription = _authenticationRepository.user.listen(
      //inside the authbloc listening for authstate change
      (user) => add(AppUserChanged(user)),
    );

    on<AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
  }

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) {
    //get the user from repo then emit event
    if (event.user.isNotEmpty) {
      Constants.user = event.user;
    }
    emit(event.user.isNotEmpty
        ? AppState.authenticated(event.user)
        : const AppState.unauthenticated());
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
