import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_tdd/core/network/network_info.dart';
import 'package:flutter_tdd/core/util/input_converter.dart';
import 'package:flutter_tdd/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:flutter_tdd/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:flutter_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_tdd/features/number_trivia/presentation/controller/number_trivia_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final getIt = GetIt.instance;
Future init() async {
  //! Features - Number Trivia
  // Bloc
  getIt.registerFactory(() => NumberTriviaController(
      concrete: getIt(), random: getIt(), inputConverter: getIt()));
  // Use cases
  getIt.registerLazySingleton<GetConcreteNumberTrivia>(
      () => GetConcreteNumberTrivia(getIt()));
  getIt.registerLazySingleton<GetRandomNumberTrivia>(
      () => GetRandomNumberTrivia(getIt()));
  // Repositories
  getIt.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          remoteDataSource: getIt(),
          localDataSource: getIt(),
          networkInfo: getIt()));
  // Data sources
  getIt.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: getIt()));
  getIt.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(getIt()));
  //! Core
  // Utils
  getIt.registerLazySingleton<InputConverter>(() => InputConverter());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerLazySingleton<http.Client>(() => http.Client());
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
}
