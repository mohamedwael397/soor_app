import 'package:soor_app/features/bookings/data/models/booking_model.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}
class BookingLoading extends BookingState {}
class BookingLoaded extends BookingState {
  final List<BookingModel> bookings;
  final int currentPage;
  final int lastPage;
  final bool hasMore;
  BookingLoaded({required this.bookings, required this.currentPage, required this.lastPage, required this.hasMore});
}
class BookingEmpty extends BookingState {}
class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
}
class BookingCreating extends BookingState {}
class BookingCreated extends BookingState {
  final BookingModel booking;
  final String message;
  BookingCreated(this.booking, this.message);
}
class BookingCreateError extends BookingState {
  final String message;
  BookingCreateError(this.message);
}
class RatingLoading extends BookingState {}
class RatingLoaded extends BookingState {
  final List<RatingCriteria> criteria;
  RatingLoaded(this.criteria);
}
class RatingSubmitting extends BookingState {}
class RatingSuccess extends BookingState {
  final String message;
  RatingSuccess(this.message);
}
class RatingError extends BookingState {
  final String message;
  RatingError(this.message);
}
class HourPriceLoading extends BookingState {}
class HourPriceLoaded extends BookingState {
  final String price;
  HourPriceLoaded(this.price);
}
