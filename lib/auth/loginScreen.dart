import 'package:driver/auth/login_bloc/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('login'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              // if (state.status == LoginUserStatus.loading) {
              //   QuickAlert.show(
              //     context: context,
              //     type: QuickAlertType.loading,
              //     title: 'Loading...............',
              //   );
              // }
              if (state.status == LoginUserStatus.failure) {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  title: 'Oops...',
                  text: 'Please Try Again',
                );
              }
              if (state.status == LoginUserStatus.success) {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  text: 'Successfully Login....!',
                );
              }
            },
            builder: (context, state) {
              return Form(
                key: key,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Login'),

                      const SizedBox(height: 15),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Email';
                          }
                          return null;
                        },
                        controller: _email,
                        decoration: InputDecoration(
                          label: const Text('Email'),
                          prefixIcon: const Icon(Icons.email),
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Password';
                          }
                          return null;
                        },
                        controller: _password,
                        decoration: InputDecoration(
                          label: const Text('Password'),
                          prefixIcon: const Icon(Icons.password),
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                          if (key.currentState!.validate()) {
                            context.read<LoginBloc>().add(
                              LoginButtonClickEvent(
                                email: _email.text,
                                password: _password.text,
                              ),
                            );
                          }
                        },
                        child: Text('Login'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
