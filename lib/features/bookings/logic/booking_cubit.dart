import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soor_app/features/bookings/data/models/booking_model.dart';
import 'package:soor_app/features/bookings/data/repo/booking_repository.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository repo;
  BookingCubit(this.repo) : super(BookingInitial());

  List<BookingModel> _all = [];
  int _currentPage = 1;
  int _lastPage = 1;
  bool _isFetchingMore = false;

  List<RatingCriteria> ratingCriteria = [];
  String? hourPrice;

  Future<void> fetchBookings({bool refresh = false}) async {
    if (refresh) {
      _all = [];
      _currentPage = 1;
      _lastPage = 1;
    }
    if (_all.isEmpty) emit(BookingLoading());
    final res = await repo.getBookings(page: _currentPage);
    res.fold(
      (l) => emit(BookingError(l.message)),
      (r) {
        _all = r.bookings;
        _currentPage = r.currentPage;
        _lastPage = r.lastPage;
        if (_all.isEmpty) emit(BookingEmpty());
        else emit(BookingLoaded(bookings: _all, currentPage: _currentPage, lastPage: _lastPage, hasMore: _currentPage < _lastPage));
      },
    );
  }

  Future<void> fetchMore() async {
    if (_isFetchingMore) return;
    if (_currentPage >= _lastPage) return;
    _isFetchingMore = true;
    final next = _currentPage + 1;
    final res = await repo.getBookings(page: next);
    res.fold(
      (l) => emit(BookingError(l.message)),
      (r) {
        _all.addAll(r.bookings);
        _currentPage = r.currentPage;
        _lastPage = r.lastPage;
        emit(BookingLoaded(bookings: List.from(_all), currentPage: _currentPage, lastPage: _lastPage, hasMore: _currentPage < _lastPage));
      },
    );
    _isFetchingMore = false;
  }

  Future<void> createBooking(CreateBookingRequest req) async {
    emit(BookingCreating());
    final res = await repo.createBooking(req);
    res.fold(
      (l) => emit(BookingCreateError(l.message)),
      (r) {
        emit(BookingCreated(r, 'تم إنشاء الحجز بنجاح'));
        // refresh list after creation
        fetchBookings(refresh: true);
      },
    );
  }

  Future<void> loadRatingCriteria() async {
    emit(RatingLoading());
    final res = await repo.getRatingCriteria();
    res.fold(
      (l) => emit(RatingError(l.message)),
      (r) {
        ratingCriteria = r;
        emit(RatingLoaded(r));
      },
    );
  }

  Future<void> rateGuard({required int bookingId, required Map<String, int> ratings}) async {
    emit(RatingSubmitting());
    final res = await repo.rateGuard(bookingId: bookingId, ratings: ratings);
    res.fold(
      (l) => emit(RatingError(l.message)),
      (_) => emit(RatingSuccess('تم إرسال التقييم بنجاح')),
    );
  }

  Future<void> loadHourPrice() async {
    emit(HourPriceLoading());
    final res = await repo.getHourPrice();
    res.fold(
      (l) => emit(BookingError(l.message)),
      (p) {
        hourPrice = p;
        emit(HourPriceLoaded(p));
      },
    );
  }

  void resetCreateState() {
    if (state is BookingCreated || state is BookingCreateError) {
      if (_all.isEmpty) emit(BookingEmpty());
      else emit(BookingLoaded(bookings: _all, currentPage: _currentPage, lastPage: _lastPage, hasMore: _currentPage < _lastPage));
    }
  }
}
