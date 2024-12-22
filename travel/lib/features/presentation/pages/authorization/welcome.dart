import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel/features/presentation/bloc/authentication/authentication/authentication_bloc.dart';
import 'package:travel/features/presentation/bloc/authentication/sign_in/sign_in_bloc.dart';
import 'package:travel/features/presentation/bloc/authentication/sign_up/sign_up_bloc.dart';
import 'package:travel/features/presentation/pages/authorization/sign_in.dart';
import 'package:travel/features/presentation/pages/authorization/sign_up.dart';
import 'package:travel/features/presentation/widgets/decoration/gradient.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getGradientDecoration(), 
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
              child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50.0),
                            child: TabBar(
                                controller: tabController,
                                unselectedLabelColor:
                                    Colors.black.withValues(),
                                labelColor: Colors.black,
                                tabs: [
                                  Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Text(
                                      'Sign In',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                          Expanded(
                              child: TabBarView(
                                  controller: tabController,
                                  children: [
                                BlocProvider<SignInBloc>(
                                  create: (context) => SignInBloc(
                                      userRepository: context
                                          .read<AuthenticationBloc>()
                                          .userRepository
                                  ),
                                  child: const SignInScreen(),
                                ),
                                BlocProvider<SignUpBloc>(
                                  create: (context) => SignUpBloc(
                                    userRepository: context
                                          .read<AuthenticationBloc>()
                                          .userRepository
                                  ),
                                  child: SignUpScreen(),
                                )
                              ]))
                        ],
                      )),
                )
              ],
            ),
          ))),
    );
  }
}
