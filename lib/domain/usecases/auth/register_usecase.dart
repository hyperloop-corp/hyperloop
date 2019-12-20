import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hyperloop/core/errors/failure.dart';
import 'package:hyperloop/core/usecases/usecase.dart';
import 'package:hyperloop/domain/entities/user.dart';
import 'package:hyperloop/domain/repositories/authentication_repository.dart';

class Register extends UseCase<User, RegisterParams> {
  final AuthenticationRepository repository;

  Register(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await repository.registerWithEmailAndPassword(
        params.email, params.password);
  }
}

class RegisterParams extends Equatable {
  final String email;
  final String password;

  RegisterParams({@required this.email, @required this.password});

  @override
  List<Object> get props => [email, password];
}
