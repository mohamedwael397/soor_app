import 'package:get_it/get_it.dart';
import 'package:soor_app/core/network/dio_client.dart';
import 'package:soor_app/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:soor_app/features/auth/data/repo/auth_repository.dart';
import 'package:soor_app/features/auth/logic/auth_cubit.dart';
import 'package:soor_app/features/bookings/data/datasource/booking_remote_datasource.dart';
import 'package:soor_app/features/bookings/data/repo/booking_repository.dart';
import 'package:soor_app/features/bookings/logic/booking_cubit.dart';
import 'package:soor_app/features/chat/data/datasource/chat_remote_datasource.dart';
import 'package:soor_app/features/chat/data/repo/chat_repository.dart';
import 'package:soor_app/features/chat/logic/chat_cubit.dart';

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

  // Booking
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(sl<BookingRemoteDataSource>()),
  );
  sl.registerFactory<BookingCubit>(() => BookingCubit(sl<BookingRepository>()));

  // Chat
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(sl<ChatRemoteDataSource>()),
  );
  sl.registerFactory<ChatCubit>(() => ChatCubit(sl<ChatRepository>()));
}
