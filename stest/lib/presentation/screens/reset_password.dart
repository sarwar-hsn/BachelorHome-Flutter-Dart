import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/cubit/passreset/passreset_cubit.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('reset pass'),
      ),
      body: Center(
          child: BlocConsumer<PassresetCubit, PassresetState>(
        listener: (context, state) {
          if (state is PassresetSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(_snackBar(
                msg: 'reset link sent to your mail', color: Colors.lightGreen));
          } else if (state is PassresetFailed) {
            ScaffoldMessenger.of(context).showSnackBar(_snackBar(
                msg: 'failed to verify your email', color: Colors.redAccent));
          }
        },
        builder: (context, state) {
          if (state is PassresetLoading) {
            return const CircularProgressIndicator();
          }
          return Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _email(context, state),
                _verifyButton(context: context, state: state, formKey: _formKey)
              ],
            ),
          );
        },
      )),
    );
  }
}

SnackBar _snackBar({required String msg, Color? color}) {
  return SnackBar(content: Text(msg), backgroundColor: color);
}

Widget _verifyButton({context, required GlobalKey<FormState> formKey, state}) {
  return OutlinedButton(
      onPressed: () {
        final _isValid = formKey.currentState?.validate();
        if (_isValid != null) {
          BlocProvider.of<PassresetCubit>(context)
              .resetPassword(email: (state as PassresetState).email.toString());
        }
      },
      child: const Text('verify'));
}

Widget _email(context, state) {
  return Container(
    padding: const EdgeInsets.all(20),
    child: TextFormField(
      onChanged: (value) {
        BlocProvider.of<PassresetCubit>(context).emailChanged(email: value);
      },
      validator: (value) {
        return (state as PassresetState).validateEmail(email: value!);
      },
      decoration: const InputDecoration(
        labelText: 'your email',
        hintText: 'enter your email to reset password',
      ),
    ),
  );
}
