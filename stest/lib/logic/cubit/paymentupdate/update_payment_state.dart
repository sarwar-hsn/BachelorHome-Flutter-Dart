part of 'update_payment_cubit.dart';

class UpdatePaymentState {
  final int value;
  UpdatePaymentState({this.value = 0});
  UpdatePaymentState copyWith(int? value) {
    return UpdatePaymentState(value: value ?? this.value);
  }

  String? validatePayment(String? value, {required Ledger ledger}) {
    if (value == null) {
      return 'field is empty';
    } else if (int.tryParse(value) == null) {
      return 'expected number';
    } else if (int.tryParse(value)! <= 0) {
      return 'invalid number';
    } else if (int.tryParse(value)! > (ledger.value - ledger.currentValue)) {
      return 'exceeding due';
    }
    return null;
  }
}

//update payement Initial state
class UpdatePaymentInitalState extends UpdatePaymentState {}

//UpdatePaymentSuccessState
class UpdatePaymentSuccessState extends UpdatePaymentState {
  final String msg;
  UpdatePaymentSuccessState({required this.msg});
}

class UpdatePaymentFailedState extends UpdatePaymentState {
  final String msg;
  UpdatePaymentFailedState({required this.msg});
}

//get ledger log
