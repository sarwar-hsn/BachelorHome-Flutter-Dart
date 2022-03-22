part of 'login_cubit.dart';

class LoginState {
  final String? email;
  final String? password;
  LoginState({this.email = '', this.password = ''});
  LoginState copyWith({String? email, String? password}) {
    return LoginState(
        email: email ?? this.email, password: password ?? this.password);
  }

  String? validateEmail({required String email}) {
    if (email.isEmpty) return 'not valid email';
    return null;
  }

  String? validatepassword({required String password}) {
    if (password.isEmpty) return 'password is empty';
    return null;
  }
}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String message;
  LoginSuccess({required this.message});
}

class LoginFailure extends LoginState {
  final String message;
  LoginFailure({required this.message});
}
