import 'package:bloc/bloc.dart';

import '../../../data/repositories/auth_repository/authentication_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository _authenticationRepository;
  LoginCubit(this._authenticationRepository) : super(LoginState());

  Future<void> startLoginProcess(
      {required String email, required String password}) async {
    state.copyWith(email: email, password: password);
    emit(LoginLoading());
    try {
      await _authenticationRepository.logInWithEmailAndPassword(
          email: email, password: password);
      emit(LoginSuccess(message: 'success'));
    } catch (e) {
      emit(LoginFailure(message: e.toString()));
      emit(state.copyWith(email: email, password: password));
    }
  }

  void emailChange({required String email}) {
    emit(state.copyWith(email: email));
  }

  void passwordChange({required String password}) {
    emit(state.copyWith(password: password));
  }
}
