import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel/features/presentation/bloc/authentication/authentication/authentication_bloc.dart';
import 'package:travel/features/presentation/bloc/landing/landing_page_bloc.dart';
import 'package:travel/features/presentation/pages/authorization/welcome.dart';
import 'package:travel/features/presentation/pages/home/landing.dart';

class AutorizationStartPage extends StatelessWidget {
  const AutorizationStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          return BlocProvider(
            create: (context) => LandingPageBloc(),
            child: const LandingPage(),
          );
        } else {
          return const WelcomePage();
        }
      },
    );
  }
}
