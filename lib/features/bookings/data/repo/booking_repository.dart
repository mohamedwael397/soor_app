import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:soor_app/core/error/failure.dart';
import 'package:soor_app/features/bookings/data/datasource/booking_remote_datasource.dart';
import 'package:soor_app/features/bookings/data/models/booking_model.dart';

abstract class BookingRepository {
  Future<Either<Failure, BookingsResponse>> getBookings({int page});
  Future<Either<Failure, BookingModel>> createBooking(CreateBookingRequest req);
  Future<Either<Failure, void>> rateGuard({required int bookingId, required Map<String, int> ratings});
  Future<Either<Failure, List<RatingCriteria>>> getRatingCriteria();
  Future<Either<Failure, String>> getHourPrice();
}

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remote;
  BookingRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, BookingsResponse>> getBookings({int page = 1}) async {
    try {
      final res = await remote.getBookings(page: page);
      return Right(res);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingModel>> createBooking(CreateBookingRequest req) async {
    try {
      final res = await remote.createBooking(req);
      return Right(res);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> rateGuard({required int bookingId, required Map<String, int> ratings}) async {
    try {
      await remote.rateGuard(bookingId: bookingId, ratings: ratings);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RatingCriteria>>> getRatingCriteria() async {
    try {
      final res = await remote.getRatingCriteria();
      return Right(res);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getHourPrice() async {
    try {
      final res = await remote.getHourPrice();
      return Right(res);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
