import 'package:dio/dio.dart';

abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);

  factory ServerFailure.fromDioError(DioException e) {
    if (e.response != null) {
      final data = e.response!.data;
      String msg = 'حدث خطأ غير متوقع';
      if (data is Map<String, dynamic>) {
        if (data['message'] != null) {
          msg = data['message'].toString();
        } else if (data['msg'] != null) {
          msg = data['msg'].toString();
        } else if (data['errors'] != null) {
          // take first error
          final errors = data['errors'];
          if (errors is Map && errors.isNotEmpty) {
            final firstKey = errors.keys.first;
            final firstVal = errors[firstKey];
            if (firstVal is List && firstVal.isNotEmpty) {
              msg = firstVal.first.toString();
            } else {
              msg = firstVal.toString();
            }
          }
        }
      }
      return ServerFailure(msg);
    } else {
      // network errors
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return const ServerFailure('انتهت مهلة الاتصال، حاول مرة أخرى');
      }
      if (e.type == DioExceptionType.connectionError) {
        return const ServerFailure('لا يوجد اتصال بالإنترنت');
      }
      return ServerFailure(e.message ?? 'حدث خطأ في الشبكة');
    }
  }

  factory ServerFailure.fromMessage(String message) =>
      ServerFailure(message);
}
