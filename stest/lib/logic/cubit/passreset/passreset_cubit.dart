import 'package:bloc/bloc.dart';
import 'package:stest/data/repositories/auth_repository/authentication_repository.dart';

part 'passreset_state.dart';

class PassresetCubit extends Cubit<PassresetState> {
  final AuthenticationRepository _authenticationRepository;
  PassresetCubit(this._authenticationRepository) : super(PassresetState());

  Future<void> resetStates() async {
    emit(PassresetInitial());
  }

  Future<void> resetPassword({required String email}) async {
    state.copyWith(email: email);
    emit(PassresetLoading());
    try {
      await _authenticationRepository.resetPass(email: email);
      emit(PassresetSuccess());
    } catch (e) {
      emit(PassresetFailed());
    }
  }

  void emailChanged({required String email}) {
    emit(state.copyWith(email: email));
  }
}
