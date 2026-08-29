import 'package:get_it/get_it.dart';
import 'package:soor_app/core/network/dio_client.dart';
import 'package:soor_app/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:soor_app/features/auth/data/repo/auth_repository.dart';
import 'package:soor_app/features/auth/logic/auth_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // Auth datasource
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<DioClient>().dio),
  );

  // Auth repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );

  // Auth cubit
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl<AuthRepository>()));
}
