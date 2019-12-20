import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hyperloop/core/errors/failure.dart';
import 'package:hyperloop/core/usecases/usecase.dart';
import 'package:hyperloop/domain/repositories/authentication_repository.dart';

class ForgotPassword extends UseCase<void, ForgotPasswordParams> {
  final AuthenticationRepository repository;

  ForgotPassword(this.repository);

  @override
  Future<Either<Failure, void>> call(ForgotPasswordParams params) async {
    return await repository.forgotPassword(params.email);
  }
}

class ForgotPasswordParams extends Equatable {
  final String email;

  ForgotPasswordParams({this.email});

  @override
  List<Object> get props => [email];
}
