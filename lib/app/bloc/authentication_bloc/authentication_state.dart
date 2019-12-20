import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hyperloop/domain/entities/user.dart';

abstract class AuthenticationState extends Equatable {}

class Uninitialized extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class Authenticated extends AuthenticationState {
  final User user;

  Authenticated({@required this.user});

  @override
  List<Object> get props => [user];
}

class Unauthenticated extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class PhoneAuthCodeSent extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationError extends AuthenticationState {
  final String message;

  AuthenticationError({@required this.message});

  @override
  List<Object> get props => [message];
}
