import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hyperloop/core/errors/failure.dart';
import 'package:hyperloop/core/usecases/usecase.dart';
import 'package:hyperloop/domain/entities/user.dart';
import 'package:hyperloop/domain/repositories/authentication_repository.dart';

class SignInWithPhoneNumber extends UseCase<User, SignInWithPhoneNumberParams> {
  final AuthenticationRepository repository;

  SignInWithPhoneNumber(this.repository);

  @override
  Future<Either<Failure, User>> call(SignInWithPhoneNumberParams params) async {
    return await repository.signInWithPhoneNumber(params.smsCode);
  }
}

class SignInWithPhoneNumberParams extends Equatable {
  final String smsCode;

  SignInWithPhoneNumberParams({this.smsCode});

  @override
  List<Object> get props => [smsCode];
}
