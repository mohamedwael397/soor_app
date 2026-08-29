import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soor_app/core/utils/storage_helper.dart';
import 'package:soor_app/core/utils/validators.dart';
import 'package:soor_app/features/auth/data/repo/auth_repository.dart';
import 'auth_state.dart';

enum OtpPurpose { register, forgetPassword }

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repo;
  AuthCubit(this.repo) : super(AuthInitial());

  String? _pendingPhone;
  OtpPurpose? _otpPurpose;
  String? _lastOtp; // محاكاة السيرفر

  String? get pendingPhone => _pendingPhone;
  OtpPurpose? get otpPurpose => _otpPurpose;
  String? get lastOtp => _lastOtp;

  void setPendingPhone(String phone, OtpPurpose purpose) {
    _pendingPhone = Validators.normalizePhone(phone);
    _otpPurpose = purpose;
  }

  Future<void> login({
    required String phone,
    required String password,
  }) async {
    emit(AuthLoading());
    final normalized = Validators.normalizePhone(phone);
    final result = await repo.login(phone: normalized, password: password);
    result.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => emit(AuthSuccess(r.message)),
    );
  }

  Future<void> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(AuthLoading());
    final normalized = Validators.normalizePhone(phone);
    final result = await repo.register(
      name: name,
      phone: normalized,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
    await result.fold(
      (l) async => emit(AuthFailure(l.message)),
      (r) async {
        _pendingPhone = normalized;
        _otpPurpose = OtpPurpose.register;
        await StorageHelper.savePhone(normalized);
        _lastOtp = r.otp;
        // Register في الـ API ده مش بيبعت OTP تلقائياً، لازم نطلب resend
        emit(OtpSending());
        final resend = await repo.resendCode(phone: normalized);
        resend.fold(
          (lf) {
            // لو فشل الـ resend نطّلع OtpSent برسالة تنبيه مع الـ otp اللي من register لو موجود
            emit(OtpSent(
                'تم إنشاء الحساب، سيتم إرسال كود التحقق الآن. إذا لم يصل اضغط إعادة إرسال',
                normalized,
                _lastOtp));
          },
          (rs) {
            _lastOtp = rs.otp ?? _lastOtp;
            emit(OtpSent(rs.message, normalized, _lastOtp));
          },
        );
      },
    );
  }

  Future<void> forgetPassword({required String phone}) async {
    emit(AuthLoading());
    final normalized = Validators.normalizePhone(phone);
    final result = await repo.forgetPassword(phone: normalized);
    result.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) {
        _pendingPhone = normalized;
        _otpPurpose = OtpPurpose.forgetPassword;
        _lastOtp = r.otp;
        StorageHelper.savePhone(normalized);
        emit(OtpSent(r.message, normalized, _lastOtp));
      },
    );
  }

  Future<void> verifyCode({required String code}) async {
    if (_pendingPhone == null) {
      emit(const AuthFailure('رقم الجوال غير موجود، أعد المحاولة'));
      return;
    }
    emit(OtpVerifying());
    final result = await repo.verifyCode(phone: _pendingPhone!, code: code);
    result.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => emit(OtpVerified(r.message)),
    );
  }

  Future<void> resendCode() async {
    if (_pendingPhone == null) {
      emit(const AuthFailure('رقم الجوال غير موجود'));
      return;
    }
    emit(OtpSending());
    final result = await repo.resendCode(phone: _pendingPhone!);
    result.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) {
        _lastOtp = r.otp ?? _lastOtp;
        emit(OtpResent(r.message, _lastOtp));
      },
    );
  }

  Future<void> resetPassword({
    required String password,
    required String passwordConfirmation,
  }) async {
    if (_pendingPhone == null) {
      emit(const AuthFailure('رقم الجوال غير موجود'));
      return;
    }
    emit(AuthLoading());
    final result = await repo.resetPassword(
      phone: _pendingPhone!,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
    result.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => emit(AuthSuccess(r.message)),
    );
  }

  void clearPending() {
    _pendingPhone = null;
    _otpPurpose = null;
    _lastOtp = null;
  }

  void reset() => emit(AuthInitial());

  Future<void> logout() async {
    await StorageHelper.clearAll();
    clearPending();
    emit(AuthInitial());
  }

  Future<void> fetchProfile() async {
    final cached = StorageHelper.getUser();
    if (cached != null) {
      emit(ProfileLoaded(cached.name ?? 'مستخدم', cached.phone ?? StorageHelper.getPhone() ?? ''));
    } else {
      emit(ProfileLoading());
    }
    final result = await repo.getProfile();
    result.fold(
      (l) {
        if (cached == null) emit(ProfileError(l.message));
      },
      (r) {
        final user = r.user ?? StorageHelper.getUser();
        if (user != null) {
          emit(ProfileLoaded(user.name ?? 'مستخدم', user.phone ?? ''));
        } else {
          emit(ProfileLoaded(StorageHelper.getUserName(), StorageHelper.getUserPhone()));
        }
      },
    );
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String email,
    String? password,
    String? confirmPassword,
  }) async {
    emit(AuthLoading());
    final normalizedPhone = Validators.normalizePhone(phone);
    final result = await repo.updateProfile(
      name: name,
      phone: normalizedPhone,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
    result.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) {
        // السيرفر رجع بيانات المستخدم الجديدة في r.user
        emit(AuthSuccess(r.message.isEmpty ? 'تم تحديث البيانات بنجاح' : r.message));
        // حدث الـ profile فوراً
        fetchProfile();
      },
    );
  }
}
