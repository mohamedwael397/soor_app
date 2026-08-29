import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:soor_app/core/error/failure.dart';
import 'package:soor_app/core/utils/storage_helper.dart';
import 'package:soor_app/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:soor_app/features/auth/data/models/auth_response.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResponse>> login({
    required String phone,
    required String password,
  });
  Future<Either<Failure, AuthResponse>> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String passwordConfirmation,
  });
  Future<Either<Failure, AuthResponse>> resendCode({required String phone});
  Future<Either<Failure, AuthResponse>> verifyCode({
    required String phone,
    required String code,
  });
  Future<Either<Failure, AuthResponse>> forgetPassword({required String phone});
  Future<Either<Failure, AuthResponse>> resetPassword({
    required String phone,
    required String password,
    required String passwordConfirmation,
  });
  Future<Either<Failure, AuthResponse>> getProfile();
  Future<Either<Failure, AuthResponse>> updateProfile({
    required String name,
    required String phone,
    required String email,
    String? password,
    String? confirmPassword,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  AuthRepositoryImpl(this.remote);

  Future<Either<Failure, AuthResponse>> _handle(
    Future<AuthResponse> Function() fn, {
    bool saveUser = true,
  }) async {
    try {
      final res = await fn();
      if (res.status == false) {
        return Left(ServerFailure(res.message));
      }
      // save token if exists
      if (res.token != null && res.token!.isNotEmpty) {
        await StorageHelper.saveToken(res.token!);
      } else if (res.user?.token != null && res.user!.token!.isNotEmpty) {
        await StorageHelper.saveToken(res.user!.token!);
      }
      if (saveUser && res.user != null) {
        await StorageHelper.saveUser(res.user!);
      }
      return Right(res);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> login({
    required String phone,
    required String password,
  }) =>
      _handle(() => remote.login(phone: phone, password: password));

  @override
  Future<Either<Failure, AuthResponse>> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) =>
      _handle(() => remote.register(
            name: name,
            phone: phone,
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation,
          ));

  @override
  Future<Either<Failure, AuthResponse>> resendCode({required String phone}) =>
      _handle(() => remote.resendCode(phone: phone));

  @override
  Future<Either<Failure, AuthResponse>> verifyCode({
    required String phone,
    required String code,
  }) =>
      _handle(() => remote.verifyCode(phone: phone, code: code));

  @override
  Future<Either<Failure, AuthResponse>> forgetPassword(
          {required String phone}) =>
      _handle(() => remote.forgetPassword(phone: phone));

  @override
  Future<Either<Failure, AuthResponse>> resetPassword({
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) =>
      _handle(() => remote.resetPassword(
            phone: phone,
            password: password,
            passwordConfirmation: passwordConfirmation,
          ));

  @override
  Future<Either<Failure, AuthResponse>> getProfile() =>
      _handle(() => remote.getProfile());

  @override
  Future<Either<Failure, AuthResponse>> updateProfile({
    required String name,
    required String phone,
    required String email,
    String? password,
    String? confirmPassword,
  }) =>
      _handle(() => remote.updateProfile(
            name: name,
            phone: phone,
            email: email,
            password: password,
            confirmPassword: confirmPassword,
          ));
}
