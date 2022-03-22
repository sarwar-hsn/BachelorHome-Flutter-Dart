part of 'passreset_cubit.dart';

class PassresetState {
  final String email;
  PassresetState({this.email = ''});
  PassresetState copyWith({String? email}) {
    return PassresetState(email: email ?? this.email);
  }

  String? validateEmail({required String email}) {
    if (email.isEmpty) return 'enter a valid email';
    return null;
  }
}

class PassresetInitial extends PassresetState {}

class PassresetLoading extends PassresetState {}

class PassresetSuccess extends PassresetState {}

class PassresetFailed extends PassresetState {}
