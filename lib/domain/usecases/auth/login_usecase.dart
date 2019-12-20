import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hyperloop/core/errors/failure.dart';
import 'package:hyperloop/core/usecases/usecase.dart';
import 'package:hyperloop/domain/entities/user.dart';
import 'package:hyperloop/domain/repositories/authentication_repository.dart';

class Login extends UseCase<User, LoginParams> {
  final AuthenticationRepository repository;

  Login(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.signInWithEmailAndPassword(
        params.email, params.password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  LoginParams({@required this.email, @required this.password});

  @override
  List<Object> get props => [email, password];
}
