import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/services/auth/bloc/auth_bloc.dart';
import 'package:notes_app/services/auth/bloc/auth_event.dart';
import 'package:notes_app/services/auth/bloc/auth_state.dart';
import 'package:notes_app/services/auth/auth_exeptions.dart';
import 'package:notes_app/utilities/dialogs/error_dialog.dart';



class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'weak password');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, 'email already in use');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'invalid email');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'failed to register');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Register")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('enter your email and password to register'),
              TextField(
                autocorrect: false,
                autofocus: true,
                enableSuggestions: false,
                keyboardType: TextInputType.emailAddress,
                controller: _email,
                decoration: const InputDecoration(hintText: "Enter Your Email"),
              ),
              TextField(
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
                controller: _password,
                decoration:
                    const InputDecoration(hintText: "Enter Your password"),
              ),
              Center(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        context
                            .read<AuthBloc>()
                            .add(AuthEventRegister(email, password));
                      },
                      child: const Text("Register"),
                    ),
                    TextButton(
                        onPressed: (() {
                          context.read<AuthBloc>().add(const AuthEventLogOut());
                        }),
                        child: const Text("Already Registered? Login Here!"))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
