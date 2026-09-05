class BookingModel {
  final int id;
  final String? status;
  final String? statusName;
  final String? price;
  final String? totalPrice;
  final String? startDatetime;
  final String? endDatetime;
  final int? guardsCount;
  final int? durationHours;
  final String? serviceName;
  final int? serviceId;
  final String? address;
  final String? areaName;
  final String? buildingName;
  final String? floor;
  final String? city;
  final String? paymentMethod;
  final bool? isFinished;
  final String? createdAt;
  final int? guardId;

  BookingModel({
    required this.id,
    this.status,
    this.statusName,
    this.price,
    this.totalPrice,
    this.startDatetime,
    this.endDatetime,
    this.guardsCount,
    this.durationHours,
    this.serviceName,
    this.serviceId,
    this.address,
    this.areaName,
    this.buildingName,
    this.floor,
    this.city,
    this.paymentMethod,
    this.isFinished,
    this.createdAt,
    this.guardId,
  });

  static int _parseId(dynamic v) {
    if (v is int) return v;
    return int.tryParse('$v') ?? 0;
  }

  static String? _str(dynamic v) => v == null ? null : v.toString();

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final id = _parseId(json['id'] ?? json['booking_id'] ?? json['order_id'] ?? json['bookingId']);
    String? status = _str(json['status'] ?? json['order_status'] ?? json['state']);
    String? statusName = _str(json['status_name'] ?? json['status_text'] ?? json['state'] ?? json['status_label'] ?? status);
    String? price = _str(json['price'] ?? json['total'] ?? json['total_price'] ?? json['amount'] ?? json['cost']);
    String? totalPrice = _str(json['total_price'] ?? json['total'] ?? price);
    String? start = _str(json['start_datetime'] ?? json['start_date'] ?? json['booking_date'] ?? json['date'] ?? json['start_at']);
    String? end = _str(json['end_datetime'] ?? json['end_date'] ?? json['end_at']);
    int? guards = json['guards_count'] == null ? (json['guards'] == null ? null : int.tryParse('${json['guards']}')) : int.tryParse('${json['guards_count']}');
    int? duration = json['duration_hours'] == null ? (json['duration'] == null ? null : int.tryParse('${json['duration']}')) : int.tryParse('${json['duration_hours']}');
    int? serviceId = json['service_id'] == null ? null : int.tryParse('${json['service_id']}');
    String? serviceName = _str(json['service_name'] ?? (json['service'] is Map ? (json['service'] as Map)['name'] ?? (json['service'] as Map)['title'] : null));
    String? area = _str(json['area_name'] ?? json['area']);
    String? building = _str(json['building_name'] ?? json['building']);
    String? floor = _str(json['floor']);
    String? city = _str(json['city']);
    String? address = _str(json['address'] ?? json['address_details'] ?? json['street'] ?? json['location']);
    String? payment = _str(json['payment_method'] ?? json['payment']);
    String? created = _str(json['created_at'] ?? json['createdAt'] ?? json['date']);
    int? guardId = json['guard_id'] == null ? (json['guard'] is Map ? int.tryParse('${(json['guard'] as Map)['id']}') : null) : int.tryParse('${json['guard_id']}');

    bool? isFinished;
    if (json['is_finished'] != null) {
      final v = json['is_finished'];
      if (v is bool) isFinished = v;
      else if (v is int) isFinished = v == 1;
      else if (v is String) isFinished = v == '1' || v == 'true';
    } else if (status != null) {
      final s = status.toLowerCase();
      isFinished = s == 'finished' || s == 'completed' || s == 'منتهي' || s == 'تم الانتهاء' || s.contains('finished');
    }

    return BookingModel(
      id: id,
      status: status,
      statusName: statusName,
      price: price,
      totalPrice: totalPrice,
      startDatetime: start,
      endDatetime: end,
      guardsCount: guards,
      durationHours: duration,
      serviceId: serviceId,
      serviceName: serviceName,
      areaName: area,
      buildingName: building,
      floor: floor,
      city: city,
      address: address,
      paymentMethod: payment,
      isFinished: isFinished,
      createdAt: created,
      guardId: guardId,
    );
  }
}

class BookingsResponse {
  final List<BookingModel> bookings;
  final int currentPage;
  final int lastPage;
  final int total;

  BookingsResponse({required this.bookings, required this.currentPage, required this.lastPage, required this.total});

  static List<dynamic>? _findBookingList(dynamic obj) {
    if (obj is List) {
      if (obj.isNotEmpty && obj.first is Map && (obj.first as Map).containsKey('id') || obj.first is Map && (obj.first as Map).containsKey('booking_id')) return obj;
      // try to find nested
      for (final v in obj) {
        if (v is Map) {
          final found = _findBookingList(v);
          if (found != null) return found;
        }
      }
    } else if (obj is Map) {
      // direct keys
      for (final k in ['data', 'bookings', 'orders', 'items', 'result', 'bookings_data']) {
        if (obj[k] is List) {
          final lst = obj[k] as List;
          if (lst.isNotEmpty && lst.first is Map) return lst;
        }
        if (obj[k] is Map) {
          final found = _findBookingList(obj[k]);
          if (found != null) return found;
        }
      }
      // paginated: data.data
      if (obj['data'] is Map && (obj['data'] as Map)['data'] is List) return (obj['data'] as Map)['data'] as List;
      // search any list value that looks like bookings
      for (final v in obj.values) {
        if (v is List && v.isNotEmpty && v.first is Map && ((v.first as Map).containsKey('id') || (v.first as Map).containsKey('booking_id'))) return v;
        if (v is Map) {
          final found = _findBookingList(v);
          if (found != null) return found;
        }
      }
    }
    return null;
  }

  factory BookingsResponse.fromJson(Map<String, dynamic> json) {
    final listRaw = _findBookingList(json);
    List<BookingModel> list = [];
    if (listRaw != null) {
      list = listRaw.map((e) => BookingModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    // pagination
    int current = 1, last = 1, total = list.length;
    dynamic pagination = json['data'] is Map ? json['data'] : json;
    if (pagination is Map) {
      if (pagination['current_page'] != null) current = int.tryParse('${pagination['current_page']}') ?? 1;
      if (pagination['last_page'] != null) last = int.tryParse('${pagination['last_page']}') ?? 1;
      if (pagination['total'] != null) total = int.tryParse('${pagination['total']}') ?? total;
      // also check meta
      if (pagination['meta'] is Map) {
        final m = pagination['meta'] as Map;
        if (m['current_page'] != null) current = int.tryParse('${m['current_page']}') ?? current;
        if (m['last_page'] != null) last = int.tryParse('${m['last_page']}') ?? last;
      }
    }
    // also try root
    if (json['current_page'] != null) current = int.tryParse('${json['current_page']}') ?? current;
    if (json['last_page'] != null) last = int.tryParse('${json['last_page']}') ?? last;

    return BookingsResponse(bookings: list, currentPage: current, lastPage: last, total: total);
  }
}

class RatingCriteria {
  final int id;
  final String name;
  RatingCriteria({required this.id, required this.name});
  factory RatingCriteria.fromJson(Map<String, dynamic> json) {
    final id = int.tryParse('${json['id']}') ?? 0;
    final name = (json['name'] ?? json['title'] ?? json['criteria'] ?? json['label'] ?? '').toString();
    return RatingCriteria(id: id, name: name);
  }
}

class HourPriceResponse {
  final String price;
  HourPriceResponse(this.price);
  factory HourPriceResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map && data['price'] != null) return HourPriceResponse(data['price'].toString());
    if (data is Map && data['hour_price'] != null) return HourPriceResponse(data['hour_price'].toString());
    if (json['price'] != null) return HourPriceResponse(json['price'].toString());
    if (json['hour_price'] != null) return HourPriceResponse(json['hour_price'].toString());
    if (json['data'] is String) return HourPriceResponse(json['data'].toString());
    // search recursively
    String? find(dynamic o) {
      if (o is Map) {
        if (o['price'] != null) return o['price'].toString();
        if (o['hour_price'] != null) return o['hour_price'].toString();
        for (final v in o.values) {
          final r = find(v);
          if (r != null) return r;
        }
      } else if (o is List && o.isNotEmpty) return find(o.first);
      return null;
    }
    final f = find(json);
    if (f != null) return HourPriceResponse(f);
    return HourPriceResponse('0');
  }
}

class CreateBookingRequest {
  final String serviceId;
  final String lat;
  final String long;
  final String areaName;
  final String buildingName;
  final String floor;
  final String addressDetails;
  final String city;
  final String region;
  final String street;
  final String startDatetime; // "2026-09-01 14:00:00"
  final String durationHours;
  final String guardsCount;
  final String dressType;
  final String language;
  final String hasCoordinator;
  final String? coordinatorName;
  final String? coordinatorPhone;
  final String? additionalNotes;
  final String paymentMethod;

  CreateBookingRequest({
    required this.serviceId,
    required this.lat,
    required this.long,
    required this.areaName,
    required this.buildingName,
    required this.floor,
    required this.addressDetails,
    required this.city,
    required this.region,
    required this.street,
    required this.startDatetime,
    required this.durationHours,
    required this.guardsCount,
    required this.dressType,
    required this.language,
    required this.hasCoordinator,
    this.coordinatorName,
    this.coordinatorPhone,
    this.additionalNotes,
    required this.paymentMethod,
  });

  Map<String, dynamic> toJson() => {
        'service_id': serviceId,
        'lat': lat,
        'long': long,
        'area_name': areaName,
        'building_name': buildingName,
        'floor': floor,
        'address_details': addressDetails,
        'city': city,
        'region': region,
        'street': street,
        'start_datetime': startDatetime,
        'duration_hours': durationHours,
        'guards_count': guardsCount,
        'dress_type': dressType,
        'language': language,
        'has_coordinator': hasCoordinator,
        if (coordinatorName != null && coordinatorName!.isNotEmpty) 'coordinator_name': coordinatorName,
        if (coordinatorPhone != null && coordinatorPhone!.isNotEmpty) 'coordinator_phone': coordinatorPhone,
        if (additionalNotes != null && additionalNotes!.isNotEmpty) 'additional_notes': additionalNotes,
        'payment_method': paymentMethod,
      };
}
