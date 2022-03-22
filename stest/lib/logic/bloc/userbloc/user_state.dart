import '../../../data/models/usermodels/user.dart';

abstract class UserState {}

class UserInitialState extends UserState {}

class NoUserState extends UserState {
  final String msg;
  NoUserState({required this.msg});
}

class UserFoundState extends UserState {
  final User foundedUser;
  UserFoundState({required this.foundedUser});
}

class AllUserState extends UserState {
  final List<User> users;
  AllUserState({required this.users});
  User? getUserById(String id) {
    if (users.isEmpty) return null;
    for (int i = 0; i < users.length; i++) {
      if (users[i].id == id) {
        return users[i];
      }
    }
    return null;
  }
}

//adding to created ledger
class AddToCreatedLedgerInitialState extends UserState {}

class AddToCreatedLedgerSuccessState extends UserState {}

class AddToCreatedLedgerFailedState extends UserState {}

//accepting a ledger

class AcceptLedgerInitState extends UserState {}

class AcceptLedgerSuccessState extends UserState {
  final String msg;
  AcceptLedgerSuccessState({required this.msg});
}

class AcceptLedgerFailedState extends UserState {
  final String msg;
  AcceptLedgerFailedState({required this.msg});
}

//rejecting a ledger

class RejectingLedgerInitState extends UserState {}

class RejectingLedgerSuccessState extends UserState {
  final String msg;
  RejectingLedgerSuccessState({required this.msg});
}

class RejectingLedgerFailedState extends UserState {
  final String msg;
  RejectingLedgerFailedState({required this.msg});
}
