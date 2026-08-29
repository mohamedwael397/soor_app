abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  const AuthSuccess(this.message);
}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
}

// OTP specific states - منفصلة عن AuthLoading/Success عشان متتداخلش مع شاشات تانية
class OtpSending extends AuthState {}

class OtpSent extends AuthState {
  final String message;
  final String phone;
  final String? otp; // محاكاة: الكود القادم من السيرفر داخل رسالة النجاح
  const OtpSent(this.message, this.phone, [this.otp]);
}

class OtpVerifying extends AuthState {}

class OtpVerified extends AuthState {
  final String message;
  const OtpVerified(this.message);
}

class OtpResent extends AuthState {
  final String message;
  final String? otp;
  const OtpResent(this.message, [this.otp]);
}

class ProfileLoading extends AuthState {}

class ProfileLoaded extends AuthState {
  final String name;
  final String phone;
  const ProfileLoaded(this.name, this.phone);
}

class ProfileError extends AuthState {
  final String message;
  const ProfileError(this.message);
}
