part of 'dues_cubit.dart';

@immutable
abstract class DuesState {}

class DuesInitial extends DuesState {}

class DuesSuccessState extends DuesState {
  final List<Due> dues;
  DuesSuccessState({required this.dues});
}

class DuesFailedState extends DuesState {
  final String msg;
  DuesFailedState({required this.msg});
}
