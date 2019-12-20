import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hyperloop/core/errors/failure.dart';
import 'package:hyperloop/core/usecases/usecase.dart';
import 'package:hyperloop/domain/entities/phone_auth_state.dart';
import 'package:hyperloop/domain/repositories/authentication_repository.dart';

class VerifyPhoneNumber extends UseCase<Stream<PhoneAuthState>, VerifyPhoneNumberParams> {
  final AuthenticationRepository repository;

  VerifyPhoneNumber(this.repository);

  @override
  Future<Either<Failure, Stream<PhoneAuthState>>> call(VerifyPhoneNumberParams params) async {
    return await repository.verifyPhoneNumber(params.phoneNumber);
  }
}

class VerifyPhoneNumberParams extends Equatable {
  final String phoneNumber;

  VerifyPhoneNumberParams({@required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}
