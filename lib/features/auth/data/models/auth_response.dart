import 'user_model.dart';

class AuthResponse {
  final bool status;
  final String message;
  final UserModel? user;
  final String? token;
  final String? otp; // للـ محاكاة - الكود المستخرج من رسالة السيرفر

  AuthResponse({
    required this.status,
    required this.message,
    this.user,
    this.token,
    this.otp,
  });

  static String? _extractOtp(Map<String, dynamic> json, String message) {
    // 1) حاول تقرأ الحقول المباشرة
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      for (final k in ['otp', 'code', 'verification_code', 'verify_code']) {
        if (data[k] != null) {
          final v = data[k].toString();
          final m = RegExp(r'\d{4,6}').firstMatch(v);
          if (m != null) return m.group(0);
        }
      }
    }
    for (final k in ['otp', 'code', 'verification_code', 'verify_code']) {
      if (json[k] != null) {
        final v = json[k].toString();
        final m = RegExp(r'\d{4,6}').firstMatch(v);
        if (m != null) return m.group(0);
      }
    }
    // 2) استخرج من رسالة النجاح نفسها (مثلاً: "كود التحقق هو 1234")
    final msgMatch = RegExp(r'\b\d{4,6}\b').firstMatch(message);
    if (msgMatch != null) return msgMatch.group(0);
    // 3) ابحث في كل الـ json كـ string
    final jsonStr = json.toString();
    final anyMatch = RegExp(r'\b\d{4,6}\b').firstMatch(jsonStr);
    // تجنب التقاط أرقام التليفون (أكثر من 6)
    if (anyMatch != null) {
      final v = anyMatch.group(0)!;
      if (v.length <= 6) return v;
    }
    return null;
  }

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    bool status = true;
    if (json.containsKey('status')) {
      final s = json['status'];
      if (s is bool) status = s;
      else if (s is int) status = s == 1;
      else if (s is String) status = s == 'true' || s == '1';
    } else if (json.containsKey('success')) {
      final s = json['success'];
      if (s is bool) status = s;
    }

    String message = json['message']?.toString() ??
        json['msg']?.toString() ??
        (status ? 'تم بنجاح' : 'حدث خطأ');

    UserModel? user;
    String? token;

    final data = json['data'];
    if (data is Map<String, dynamic>) {
      token = data['token']?.toString() ??
          data['access_token']?.toString() ??
          json['token']?.toString();

      if (data['user'] is Map<String, dynamic>) {
        user = UserModel.fromJson(data['user']);
        token ??= user.token;
      } else if (data.containsKey('id') ||
          data.containsKey('name') ||
          data.containsKey('user_id') ||
          data.containsKey('user_name') ||
          data.containsKey('user_phone') ||
          data.containsKey('user_email')) {
        user = UserModel.fromJson(data);
        token ??= user.token;
      }
      if ((message == 'تم بنجاح' || message.isEmpty) && data['message'] != null) {
        message = data['message'].toString();
      }
    } else if (data is List && data.isNotEmpty && data.first is Map<String, dynamic>) {
      // بعض الـ APIs ترجع data كـ list
      user = UserModel.fromJson(data.first as Map<String, dynamic>);
    }

    token ??= json['token']?.toString() ?? json['access_token']?.toString();

    if (user == null && json['user'] is Map) {
      user = UserModel.fromJson(json['user'] as Map<String, dynamic>);
    }
    // لو لسه null و الـ json نفسه فيه user_*
    if (user == null &&
        (json.containsKey('user_id') ||
            json.containsKey('user_name') ||
            json.containsKey('user_phone'))) {
      user = UserModel.fromJson(json);
    }

    final otp = _extractOtp(json, message);

    return AuthResponse(
      status: status,
      message: message,
      user: user,
      token: token,
      otp: otp,
    );
  }
}
