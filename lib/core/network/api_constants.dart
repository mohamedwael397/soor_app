class ApiConstants {
  static const String baseUrl = 'https://soor.sys-web.net/api/v1';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String resendCode = '/auth/resend-verification-code';
  static const String verifyCode = '/auth/verify-code';
  static const String forgetPassword = '/auth/forget-password';
  static const String resetPassword = '/auth/reset-password';
  static const String deleteAccount = '/auth/delete-account';
  static const String profile = '/auth/profile';
  static const String updateProfile = '/auth/update-profile';

  // Home / Services
  static const String sliders = '/sliders';
  static const String services = '/services';
  static const String workPeriods = '/work-periods';
  static const String hourPrice = '/hour_price';
  static const String termsConditions = '/terms_conditions';

  // Bookings
  static const String bookings = '/bookings';
  static String rateGuard(int bookingId) => '/bookings/$bookingId/rate-guard';
  static const String ratingCriteria = '/rating-criteria';

  // Chat
  static const String chatRooms = '/chat/rooms';
  static const String chatStartRoom = '/chat/rooms/start';
  static String chatMessages(int roomId) => '/chat/rooms/$roomId/messages';
}
