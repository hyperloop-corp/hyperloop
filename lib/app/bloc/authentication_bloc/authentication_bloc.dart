import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:hyperloop/app/bloc/authentication_bloc/authentication_event.dart';
import 'package:hyperloop/app/bloc/authentication_bloc/authentication_state.dart';
import 'package:hyperloop/core/errors/failure.dart';
import 'package:hyperloop/core/usecases/usecase.dart';
import 'package:hyperloop/domain/entities/phone_auth_state.dart';
import 'package:hyperloop/domain/entities/user.dart';
import 'package:hyperloop/domain/usecases/auth/get_auth_status_usecase.dart';
import 'package:hyperloop/domain/usecases/auth/logout_usecase.dart';
import 'package:hyperloop/domain/usecases/auth/signin_with_phone_number_usercase.dart';
import 'package:hyperloop/domain/usecases/auth/verify_phone_number_usecase.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String UNEXPECTED_ERROR_MESSAGE = 'Unexpected error';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final GetAuthStatus getAuthStatus;
  final VerifyPhoneNumber verifyPhoneNumber;
  final SignInWithPhoneNumber signInWithPhoneNumber;
  final Logout logout;

  StreamSubscription _authUserSubscription;
  StreamSubscription _phoneAuthStateSubscription;

  AuthenticationBloc(
      {@required this.getAuthStatus,
      @required this.verifyPhoneNumber,
      @required this.signInWithPhoneNumber,
      @required this.logout});

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    print('AuthenticationEvent: ' + event.toString());
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState(event);
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    } else if (event is VerifyPhone) {
      yield* _mapVerifyPhoneToState(event);
    } else if (event is SignInWithPhone) {
      yield* _mapSignInWithPhoneToState(event);
    } else if (event is CodeSent) {
      yield* _mapCodeSentToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final failureOrAuthStatus = await getAuthStatus(NoParams());
      yield* failureOrAuthStatus.fold(
          (failure) =>
              Stream.value(AuthenticationError(message: _mapFailureToMessage(failure))),
          (userStream) => _mapAuthUserToState(userStream));
    } catch (e) {
      yield AuthenticationError(message: UNEXPECTED_ERROR_MESSAGE);
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState(LoggedIn event) async* {
    try {
      yield Authenticated(user: event.user);
    } catch (e) {
      yield AuthenticationError(message: UNEXPECTED_ERROR_MESSAGE);
    }
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    try {
      yield Unauthenticated();
    } catch (e) {
      yield AuthenticationError(message: UNEXPECTED_ERROR_MESSAGE);
    }
  }

  Stream<AuthenticationState> _mapVerifyPhoneToState(VerifyPhone event) async* {
    try {
      final failureOrAuthState = await verifyPhoneNumber(
          VerifyPhoneNumberParams(phoneNumber: event.phoneNumber));
      yield* failureOrAuthState.fold(
          (failure) =>
              Stream.value(AuthenticationError(message: _mapFailureToMessage(failure))),
          (authStateStream) => _mapAuthStateToState(authStateStream));
    } catch (e) {
      yield AuthenticationError(message: UNEXPECTED_ERROR_MESSAGE);
    }
  }

  Stream<AuthenticationState> _mapCodeSentToState() async* {
    yield PhoneAuthCodeSent();
  }

  Stream<AuthenticationState> _mapSignInWithPhoneToState(
      SignInWithPhone event) async* {
    try {
      final failureOrUser = await signInWithPhoneNumber(
          SignInWithPhoneNumberParams(smsCode: event.smsCode));
      yield failureOrUser.fold(
          (failure) => AuthenticationError(message: _mapFailureToMessage(failure)),
          (user) =>
              user != null ? Authenticated(user: user) : Unauthenticated());
    } catch (e) {
      yield AuthenticationError(message: UNEXPECTED_ERROR_MESSAGE);
    }
  }

  Stream<AuthenticationState> _mapAuthUserToState(
      Stream<User> userStream) async* {
    _authUserSubscription?.cancel();
    _authUserSubscription = userStream.listen((user) {
      if (user != null) {
        add(LoggedIn(user: user));
      } else {
        add(LoggedOut());
      }
    });
  }

  Stream<AuthenticationState> _mapAuthStateToState(
      Stream<PhoneAuthState> authStateStream) async* {
    _phoneAuthStateSubscription?.cancel();
    _phoneAuthStateSubscription = authStateStream.listen((authState) {
      print(authState);
      if (authState == PhoneAuthState.CodeSent) {
        add(CodeSent());
      }
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      default:
        return UNEXPECTED_ERROR_MESSAGE;
    }
  }

  @override
  Future<void> close() {
    _authUserSubscription.cancel();
    return super.close();
  }
}
