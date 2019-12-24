import 'package:equatable/equatable.dart';
import 'package:hyperloop/domain/entities/user.dart';

abstract class AuthenticationEvent extends Equatable {}

class AppStarted extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class InvokeVerifyPhone extends AuthenticationEvent {
  final String phoneNumber;

  InvokeVerifyPhone({this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}

class CodeSent extends AuthenticationEvent {
  CodeSent();

  @override
  List<Object> get props => [];
}

class InvokeSignInWithPhone extends AuthenticationEvent {
  final String smsCode;

  InvokeSignInWithPhone({this.smsCode});

  @override
  List<Object> get props => [smsCode];
}

class InvokeSignInWithEmail extends AuthenticationEvent {
  final String email;
  final String password;

  InvokeSignInWithEmail({this.email, this.password});

  @override
  List<Object> get props => [email, password];
}

class InvokeSignInWithGoogle extends AuthenticationEvent {
  InvokeSignInWithGoogle();

  @override
  List<Object> get props => [];
}

class InvokeSignOut extends AuthenticationEvent {
  InvokeSignOut();

  @override
  List<Object> get props => [];
}

class LoggedIn extends AuthenticationEvent {
  final User user;

  LoggedIn({this.user});

  @override
  List<Object> get props => [user];
}

class LoggedOut extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}
