import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyperloop/app/bloc/authentication_bloc/bloc.dart';
import 'package:hyperloop/app/pages/login/login_email_card.dart';
import 'package:hyperloop/app/pages/login/login_main_card.dart';
import 'package:hyperloop/app/pages/login/login_phone_card.dart';

enum LoginCardState { Main, Google, Facebook, Phone, Email }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginCardState _loginCard;

  @override
  void initState() {
    _loginCard = LoginCardState.Main;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(child: _getCard(context)),
        ),
      ),
    );
  }

  Widget _getCard(BuildContext context) {
    if (_loginCard == LoginCardState.Main) {
      return LoginMainCard(
          onInvokeGoogleSignIn: onInvokeGoogleSignIn,
          onInvokeFacebookSignIn: onInvokeFacebookSignIn,
          onInvokePhoneSignIn: onInvokePhoneSignIn,
          onInvokeEmailSignIn: onInvokeEmailSignIn,
          onBackPress: () {
            this.setState(() {
              _loginCard = LoginCardState.Main;
            });
          });
    } else if (_loginCard == LoginCardState.Phone) {
      return LoginPhoneCard(onBackPress: () {
        this.setState(() {
          _loginCard = LoginCardState.Main;
        });
      });
    } else if (_loginCard == LoginCardState.Email) {
      return LoginEmailCard(onBackPress: () {
        this.setState(() {
          _loginCard = LoginCardState.Main;
        });
      });
    }
    return Center(child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircularProgressIndicator(),
    ));
  }

  void onInvokeGoogleSignIn() {
    BlocProvider.of<AuthenticationBloc>(context).add(InvokeSignInWithGoogle());
  }

  void onInvokeFacebookSignIn() {}

  void onInvokePhoneSignIn() {
    setState(() {
      _loginCard = LoginCardState.Phone;
    });
  }

  void onInvokeEmailSignIn() {
    setState(() {
      _loginCard = LoginCardState.Email;
    });
  }
}
