import 'package:dio/dio.dart';
import 'package:soor_app/core/network/api_constants.dart';
import 'package:soor_app/features/auth/data/models/auth_response.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> login({
    required String phone,
    required String password,
    String? onesignalId,
  });
  Future<AuthResponse> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? onesignalId,
  });
  Future<AuthResponse> resendCode({required String phone});
  Future<AuthResponse> verifyCode({
    required String phone,
    required String code,
  });
  Future<AuthResponse> forgetPassword({required String phone});
  Future<AuthResponse> resetPassword({
    required String phone,
    required String password,
    required String passwordConfirmation,
  });
  Future<AuthResponse> getProfile();
  Future<AuthResponse> updateProfile({
    required String name,
    required String phone,
    required String email,
    String? password,
    String? confirmPassword,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<AuthResponse> login({
    required String phone,
    required String password,
    String? onesignalId,
  }) async {
    final res = await dio.post(ApiConstants.login, data: {
      'phone': phone,
      'password': password,
      if (onesignalId != null) 'onesignal_id': onesignalId,
    });
    return AuthResponse.fromJson(res.data);
  }

  @override
  Future<AuthResponse> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? onesignalId,
  }) async {
    final res = await dio.post(ApiConstants.register, data: {
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'user_type': 'user',
      'terms_accepted': 1,
      if (onesignalId != null) 'onesignal_id': onesignalId,
    });
    return AuthResponse.fromJson(res.data);
  }

  @override
  Future<AuthResponse> resendCode({required String phone}) async {
    final res = await dio.post(ApiConstants.resendCode, data: {
      'phone': phone,
    });
    return AuthResponse.fromJson(res.data);
  }

  @override
  Future<AuthResponse> verifyCode({
    required String phone,
    required String code,
  }) async {
    final res = await dio.post(ApiConstants.verifyCode, data: {
      'phone': phone,
      'verification_code': code,
    });
    return AuthResponse.fromJson(res.data);
  }

  @override
  Future<AuthResponse> forgetPassword({required String phone}) async {
    final res = await dio.post(ApiConstants.forgetPassword, data: {
      'phone': phone,
    });
    return AuthResponse.fromJson(res.data);
  }

  @override
  Future<AuthResponse> resetPassword({
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    final res = await dio.post(ApiConstants.resetPassword, data: {
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
    return AuthResponse.fromJson(res.data);
  }

  @override
  Future<AuthResponse> getProfile() async {
    final res = await dio.get(ApiConstants.profile);
    return AuthResponse.fromJson(res.data);
  }

  @override
  Future<AuthResponse> updateProfile({
    required String name,
    required String phone,
    required String email,
    String? password,
    String? confirmPassword,
  }) async {
    final data = {
      'name': name,
      'phone': phone,
      'email': email,
      if (password != null && password.isNotEmpty) 'password': password,
      if (confirmPassword != null && confirmPassword.isNotEmpty) 'confirm_password': confirmPassword,
      // بعض السيرفرات متوقعة password_confirmation
      if (password != null && password.isNotEmpty) 'password_confirmation': confirmPassword ?? password,
    };
    final res = await dio.post(ApiConstants.updateProfile, data: data);
    return AuthResponse.fromJson(res.data);
  }
}
