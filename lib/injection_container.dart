import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:hyperloop/app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:hyperloop/app/bloc/country_bloc/bloc.dart';
import 'package:hyperloop/core/network/network_info.dart';
import 'package:hyperloop/data/repositories/authentication_repository_impl.dart';
import 'package:hyperloop/data/repositories/country_repository_impl.dart';
import 'package:hyperloop/data/repositories/location_repository_impl.dart';
import 'package:hyperloop/data/repositories/user_repository_impl.dart';
import 'package:hyperloop/data/store/auth_store.dart';
import 'package:hyperloop/data/store/country_store.dart';
import 'package:hyperloop/data/store/firebase/firebase_auth_store.dart';
import 'package:hyperloop/data/store/firebase/firebase_country_store.dart';
import 'package:hyperloop/data/store/firebase/firebase_user_store.dart';
import 'package:hyperloop/data/store/user_store.dart';
import 'package:hyperloop/domain/repositories/authentication_repository.dart';
import 'package:hyperloop/domain/repositories/country_repository.dart';
import 'package:hyperloop/domain/repositories/location_repository.dart';
import 'package:hyperloop/domain/repositories/user_repository.dart';
import 'package:hyperloop/domain/usecases/auth/forgot_password_usecase.dart';
import 'package:hyperloop/domain/usecases/auth/get_auth_status_usecase.dart';
import 'package:hyperloop/domain/usecases/auth/get_auth_user_usecase.dart';
import 'package:hyperloop/domain/usecases/auth/login_usecase.dart';
import 'package:hyperloop/domain/usecases/auth/logout_usecase.dart';
import 'package:hyperloop/domain/usecases/auth/register_usecase.dart';
import 'package:hyperloop/domain/usecases/auth/signin_with_phone_number_usercase.dart';
import 'package:hyperloop/domain/usecases/auth/verify_phone_number_usecase.dart';
import 'package:hyperloop/domain/usecases/country/get_countries_usercase.dart';
import 'package:location/location.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory<AuthenticationBloc>(
    () => AuthenticationBloc(
        getAuthStatus: sl(),
        verifyPhoneNumber: sl(),
        signInWithPhoneNumber: sl(),
        logout: sl()),
  );

  sl.registerFactory<CountryBloc>(
    () => CountryBloc(getCountries: sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => GetAuthStatus(sl()));
  sl.registerLazySingleton(() => GetAuthUser(sl()));
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => Register(sl()));
  sl.registerLazySingleton(() => VerifyPhoneNumber(sl()));
  sl.registerLazySingleton(() => SignInWithPhoneNumber(sl()));
  sl.registerLazySingleton(() => ForgotPassword(sl()));
  sl.registerLazySingleton(() => GetCountries(sl()));

  // Repository
  sl.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(authStore: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(userStore: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton<CountryRepository>(
    () => CountryRepositoryImpl(countryStore: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(sl()),
  );

  // Data stores
  sl.registerLazySingleton<AuthStore>(
    () => FirebaseAuthStore(auth: sl()),
  );

  sl.registerLazySingleton<UserStore>(
    () => FirebaseUserStore(store: sl()),
  );

  sl.registerLazySingleton<CountryStore>(
    () => FirebaseCountryStore(store: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  sl.registerLazySingleton<Firestore>(() => Firestore.instance);

  sl.registerLazySingleton<Location>(() => Location());

  sl.registerLazySingleton<DataConnectionChecker>(
      () => DataConnectionChecker());
}
