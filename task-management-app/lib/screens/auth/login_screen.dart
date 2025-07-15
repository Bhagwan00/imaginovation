import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/ui_components/input_field.dart';

import '../../config/app_constants.dart';
import '../../config/colors.dart';
import '../../config/input_styles.dart';
import '../../config/paddings.dart';
import '../../config/route_constants.dart';
import '../../config/text_styles.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/auth/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController cEmail = TextEditingController();
  TextEditingController cPassword = TextEditingController();
  final _form = GlobalKey<FormState>();
  late AuthCubit authCubit;
  bool _isPasswordShow = true;

  @override
  void initState() {
    authCubit = context.read<AuthCubit>();
    super.initState();
  }

  void submitForm() async {
    bool isValid = _form.currentState!.validate();
    if (isValid) {
      _form.currentState!.save();
      FocusScope.of(context).requestFocus(FocusNode());
      authCubit.login(cEmail.text, cPassword.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: kPadding,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _form,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 150.0,
                      ),
                      Center(
                        child: Text(
                          appName,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      const Text(
                        'Email',
                        style: kTextStyle,
                      ),
                      InputField(
                        controller: cEmail,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Please enter email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'Password',
                        style: kTextStyle,
                      ),
                      TextFormField(
                        controller: cPassword,
                        obscureText: _isPasswordShow,
                        cursorColor: kSecondaryColor,
                        decoration: kInputStyle.copyWith(
                          suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordShow
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordShow = !_isPasswordShow;
                                });
                              }),
                          labelStyle: const TextStyle(
                              fontSize: 16, color: kSecondaryColor),
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 4.0, top: 4.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter password';
                          }
                          if (value.length < 6) {
                            return 'Password should be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      BlocConsumer<AuthCubit, AuthState>(
                        listener: (context, state) {
                          if (state is AuthLoggedInState) {
                            Navigator.pushReplacementNamed(context, homeRoute);
                          }
                        },
                        builder: (context, state) {
                          if (state is AuthLoadingState) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Column(
                            children: [
                              if (state is AuthErrorState) ...[
                                Text(
                                  state.error,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: kErrorColor,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                              SizedBox(
                                width: double.infinity,
                                height: 45,
                                child: ElevatedButton(
                                  onPressed: submitForm,
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: kPrimaryColor,
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: kWhiteColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
