import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stest/logic/cubit/login/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bachelor Point'),
            _emailField(),
            _passwordField(),
            _submitButton(),
            OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/resetpassword');
                },
                child: const Text('reset password'))
          ],
        ),
      ),
    ));
  }

  Widget _submitButton() {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return OutlinedButton(
            onPressed: () {
              bool? isValid = _formKey.currentState?.validate();
              if (isValid != null) {
                BlocProvider.of<LoginCubit>(context).startLoginProcess(
                    email: state.email.toString(),
                    password: state.password.toString());
              }
            },
            child: (state is LoginLoading)
                ? const CircularProgressIndicator()
                : const Text('login'));
      },
    );
  }

  Widget _emailField() {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: TextFormField(
            onChanged: (value) {
              BlocProvider.of<LoginCubit>(context).emailChange(email: value);
            },
            validator: (value) {
              return state.validateEmail(email: value!);
            },
            decoration: const InputDecoration(
              labelText: 'email',
              hintText: 'enter your email',
            ),
          ),
        );
      },
    );
  }

  Widget _passwordField() {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: TextFormField(
            onChanged: (value) {
              BlocProvider.of<LoginCubit>(context)
                  .passwordChange(password: value);
            },
            validator: (value) {
              return state.validatepassword(password: value!);
            },
            decoration: const InputDecoration(
              labelText: 'password',
              hintText: 'password',
            ),
          ),
        );
      },
    );
  }
}
