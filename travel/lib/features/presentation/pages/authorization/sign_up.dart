import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel/features/data/models/user.dart';
import 'package:travel/features/presentation/bloc/authentication/sign_up/sign_up_bloc.dart';
import 'package:travel/features/presentation/widgets/decoration/text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  bool signUpRequired = false;

  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;
  String? _errorMsg;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          setState(() {
            signUpRequired = false;
          });
        } else if (state is SignUpProcess) {
          setState(() {
            signUpRequired = true;
          });
        } else if (state is SignUpFailure) {
          setState(() {
            _errorMsg = state.message; 
            signUpRequired = false; 
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        
        body: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: CustomTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(CupertinoIcons.mail_solid),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please fill in this field';
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$').hasMatch(val)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: CustomTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: obscurePassword,
                    keyboardType: TextInputType.visiblePassword,
                    prefixIcon: const Icon(CupertinoIcons.lock_fill),
                    onChanged: (val) {
                      setState(() {
                        containsUpperCase = val?.contains(RegExp(r'[A-Z]')) ?? false;
                        containsLowerCase = val?.contains(RegExp(r'[a-z]')) ?? false;
                        containsNumber = val?.contains(RegExp(r'[0-9]')) ?? false;
                        containsSpecialChar = val?.contains(RegExp(r'^(?=.*?[!@#$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^])')) ?? false;
                        contains8Length = (val?.length ?? 0) >= 8;
                      });
                      return null;
                    },
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                          iconPassword = obscurePassword ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill;
                        });
                      },
                      icon: Icon(iconPassword),
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please fill in this field';
                      } else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$').hasMatch(val)) {
                        return 'Please enter a valid password';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "⚈  1 uppercase",
                          style: TextStyle(color: containsUpperCase ? Colors.green : Theme.of(context).colorScheme.onSurface),
                        ),
                        Text(
                          "⚈  1 lowercase",
                          style: TextStyle(color: containsLowerCase ? Colors.green : Theme.of(context).colorScheme.onSurface),
                        ),
                        Text(
                          "⚈  1 number",
                          style: TextStyle(color: containsNumber ? Colors.green : Theme.of(context).colorScheme.onSurface),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "⚈  1 special character",
                          style: TextStyle(color: containsSpecialChar ? Colors.green : Theme.of(context).colorScheme.onSurface),
                        ),
                        Text(
                          "⚈  8 minimum characters",
                          style: TextStyle(color: contains8Length ? Colors.green : Theme.of(context).colorScheme.onSurface),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: CustomTextField(
                    controller: nameController,
                    hintText: 'Name',
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    prefixIcon: const Icon(CupertinoIcons.person_fill),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please fill in this field';
                      } else if (val.length > 30) {
                        return 'Name too long';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                if (_errorMsg != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      _errorMsg!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                !signUpRequired
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              UserModel myUser = UserModel.empty.copyWith(
                                email: emailController.text,
                                name: nameController.text,
                              );
                              setState(() {
                                context.read<SignUpBloc>().add(
                                  SignUpRequired(myUser, passwordController.text),
                                );
                              });
                            }
                          },
                          style: TextButton.styleFrom(
                            elevation: 3.0,
                            backgroundColor: Color.fromRGBO(218, 172, 172, 1),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                            child: Text(
                              'Sign Up',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
