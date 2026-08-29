class Validators {
  // Accepts any phone number (international)
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'من فضلك ادخل رقم الجوال';
    }
    final v = value.trim();
    // keep only digits to check length, allow +, spaces, dashes, ()
    final digitsOnly = v.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length < 7 || digitsOnly.length > 15) {
      return 'رقم الجوال غير صحيح';
    }
    // must contain only allowed chars: + digits space - ( )
    final allowed = RegExp(r'^\+?[0-9\s\-\(\)]+$');
    if (!allowed.hasMatch(v)) {
      return 'رقم الجوال غير صحيح';
    }
    return null;
  }

  static String normalizePhone(String phone) {
    var p = phone.trim().replaceAll(RegExp(r'[\s\-\(\)]'), '');
    // لو رقم سعودي محلي حوله لـ +966
    if (p.startsWith('0') && p.length >= 10) {
      // 0500000000 -> +966500000000
      p = '+966${p.substring(1)}';
    } else if (p.startsWith('966') && !p.startsWith('+')) {
      p = '+$p';
    } else if (RegExp(r'^5\d{8}$').hasMatch(p)) {
      p = '+966$p';
    } else if (!p.startsWith('+') && RegExp(r'^[0-9]+$').hasMatch(p)) {
      // أي رقم دولي بدون + نضيف +
      p = '+$p';
    }
    return p;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'من فضلك ادخل البريد الإلكتروني';
    }
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value.trim())) return 'البريد الإلكتروني غير صحيح';
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return 'من فضلك ادخل الاسم';
    if (value.trim().length < 3) return 'الاسم يجب ألا يقل عن 3 أحرف';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'من فضلك ادخل كلمة المرور';
    if (value.length < 6) return 'كلمة المرور يجب ألا تقل عن 6 أحرف';
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return 'من فضلك أكد كلمة المرور';
    if (value != original) return 'كلمة المرور غير متطابقة';
    return null;
  }
}
