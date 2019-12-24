import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hyperloop/core/errors/failure.dart';
import 'package:hyperloop/core/usecases/usecase.dart';
import 'package:hyperloop/domain/entities/user.dart';
import 'package:hyperloop/domain/repositories/authentication_repository.dart';

class SignInWithEmail extends UseCase<User, SignInWithEmailParams> {
  final AuthenticationRepository repository;

  SignInWithEmail(this.repository);

  @override
  Future<Either<Failure, User>> call(SignInWithEmailParams params) async {
    return await repository.signInWithEmailAndPassword(
        params.email, params.password);
  }
}

class SignInWithEmailParams extends Equatable {
  final String email;
  final String password;

  SignInWithEmailParams({@required this.email, @required this.password});

  @override
  List<Object> get props => [email, password];
}
