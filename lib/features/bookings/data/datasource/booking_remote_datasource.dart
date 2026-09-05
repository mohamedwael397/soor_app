import 'package:dio/dio.dart';
import 'package:soor_app/core/network/api_constants.dart';
import 'package:soor_app/features/bookings/data/models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<BookingsResponse> getBookings({int page = 1});
  Future<BookingModel> createBooking(CreateBookingRequest request);
  Future<void> rateGuard({required int bookingId, required Map<String, int> ratings});
  Future<List<RatingCriteria>> getRatingCriteria();
  Future<String> getHourPrice();
  Future<List<Map<String, dynamic>>> getServices({int perPage = 1000});
  Future<List<Map<String, dynamic>>> getWorkPeriods();
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final Dio dio;
  BookingRemoteDataSourceImpl(this.dio);

  @override
  Future<BookingsResponse> getBookings({int page = 1}) async {
    final res = await dio.get(ApiConstants.bookings, queryParameters: {'page': page});
    final data = res.data;
    if (data is Map<String, dynamic>) return BookingsResponse.fromJson(data);
    if (data is List) return BookingsResponse.fromJson({'data': data});
    return BookingsResponse(bookings: [], currentPage: 1, lastPage: 1, total: 0);
  }

  @override
  Future<BookingModel> createBooking(CreateBookingRequest request) async {
    final res = await dio.post(ApiConstants.bookings, data: request.toJson());
    final data = res.data;
    if (data is Map<String, dynamic>) {
      // حالات مختلفة
      if (data['data'] is Map<String, dynamic> && (data['data'] as Map).containsKey('id')) {
        return BookingModel.fromJson(data['data'] as Map<String, dynamic>);
      }
      if (data['data'] is Map && (data['data'] as Map)['booking'] is Map) {
        return BookingModel.fromJson((data['data'] as Map)['booking'] as Map<String, dynamic>);
      }
      if (data['booking'] is Map<String, dynamic>) return BookingModel.fromJson(data['booking'] as Map<String, dynamic>);
      if (data['data'] is Map && (data['data'] as Map)['data'] is Map) {
        return BookingModel.fromJson((data['data'] as Map)['data'] as Map<String, dynamic>);
      }
      if (data['id'] != null) return BookingModel.fromJson(data);
      // لو السيرفر رجع success بدون id (نادر) نعتبره نجاح
      if (data['status'] == true || data['status'] == 1 || data['success'] == true) {
        return BookingModel(id: 0, price: '0');
      }
    }
    throw DioException(requestOptions: res.requestOptions, response: res, error: 'Create booking: unexpected response $data');
  }

  @override
  Future<void> rateGuard({required int bookingId, required Map<String, int> ratings}) async {
    await dio.post(ApiConstants.rateGuard(bookingId), data: {'ratings': ratings});
  }

  @override
  Future<List<RatingCriteria>> getRatingCriteria() async {
    final res = await dio.get(ApiConstants.ratingCriteria);
    final data = res.data;
    List list = [];
    if (data is Map && data['data'] is List) list = data['data'];
    else if (data is Map && data['data'] is Map && data['data']['data'] is List) list = data['data']['data'];
    else if (data is List) list = data;
    else if (data is Map) {
      // ابحث عن أي List داخل
      for (final v in data.values) {
        if (v is List && v.isNotEmpty) { list = v; break; }
        if (v is Map && v['data'] is List) { list = v['data']; break; }
      }
    }
    return list.map((e) => RatingCriteria.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<String> getHourPrice() async {
    final res = await dio.get(ApiConstants.hourPrice);
    final data = res.data;
    if (data is Map<String, dynamic>) return HourPriceResponse.fromJson(data).price;
    return '0';
  }

  @override
  Future<List<Map<String, dynamic>>> getServices({int perPage = 1000}) async {
    final res = await dio.get(ApiConstants.services, queryParameters: {'per_page': perPage});
    final data = res.data;
    if (data is Map && data['data'] is List) return (data['data'] as List).cast<Map<String, dynamic>>();
    if (data is Map && data['data'] is Map && data['data']['data'] is List) return (data['data']['data'] as List).cast<Map<String, dynamic>>();
    if (data is List) return data.cast<Map<String, dynamic>>();
    // search fallback
    if (data is Map) {
      for (final v in data.values) {
        if (v is List) return v.cast<Map<String, dynamic>>();
        if (v is Map && v['data'] is List) return (v['data'] as List).cast<Map<String, dynamic>>();
      }
    }
    return [];
  }

  @override
  Future<List<Map<String, dynamic>>> getWorkPeriods() async {
    final res = await dio.get(ApiConstants.workPeriods);
    final data = res.data;
    if (data is Map && data['data'] is List) return (data['data'] as List).cast<Map<String, dynamic>>();
    if (data is List) return data.cast<Map<String, dynamic>>();
    if (data is Map) {
      for (final v in data.values) if (v is List) return v.cast<Map<String, dynamic>>();
    }
    return [];
  }
}
