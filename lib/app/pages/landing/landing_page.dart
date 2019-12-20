import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyperloop/app/bloc/authentication_bloc/bloc.dart';
import 'package:hyperloop/app/pages/error/error_page.dart';
import 'package:hyperloop/app/pages/home/home_page.dart';
import 'package:hyperloop/app/pages/login/login_page.dart';
import 'package:hyperloop/app/pages/splash/splash_screen.dart';
import 'package:hyperloop/injection_container.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthenticationBloc>()..add(AppStarted()),
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          print('AuthenticationState: ' + state.toString());
          if (state is Uninitialized) {
            return SplashScreen();
          } else if (state is Authenticated) {
            return HomePage();
          } else if (state is Unauthenticated || state is PhoneAuthCodeSent) {
            return LoginPage();
          } else if (state is AuthenticationError) {
            print('Error: ' + state.message);
            return ErrorPage();
          }
          return ErrorPage();
        },
      ),
    );
  }
}
