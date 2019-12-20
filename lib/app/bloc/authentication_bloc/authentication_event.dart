import 'package:equatable/equatable.dart';
import 'package:hyperloop/domain/entities/user.dart';

abstract class AuthenticationEvent extends Equatable {}

class AppStarted extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class VerifyPhone extends AuthenticationEvent {
  final String phoneNumber;

  VerifyPhone({this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}

class CodeSent extends AuthenticationEvent {
  CodeSent();

  @override
  List<Object> get props => [];
}

class SignInWithPhone extends AuthenticationEvent {
  final String smsCode;

  SignInWithPhone({this.smsCode});

  @override
  List<Object> get props => [smsCode];
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
