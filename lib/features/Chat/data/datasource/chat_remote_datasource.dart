import 'package:dio/dio.dart';
import 'package:soor_app/core/network/api_constants.dart';
import 'package:soor_app/core/utils/storage_helper.dart';
import 'package:soor_app/features/chat/data/models/chat_models.dart';

abstract class ChatRemoteDataSource {
  Future<ChatRoomsResponse> getChatRooms({int perPage = 1000000});
  Future<ChatRoomModel> createRoom({required int bookingId, required int userId, required int guardId});
  Future<ChatMessagesResponse> getMessages({required int roomId, int perPage = 1000000});
  Future<ChatMessageModel> sendMessage({required int roomId, required int bookingId, required int senderId, required String message});
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio dio;
  ChatRemoteDataSourceImpl(this.dio);

  @override
  Future<ChatRoomsResponse> getChatRooms({int perPage = 1000000}) async {
    final res = await dio.get(ApiConstants.chatRooms, queryParameters: {'per_page': perPage});
    final data = res.data;
    if (data is Map<String, dynamic>) return ChatRoomsResponse.fromJson(data);
    if (data is List) return ChatRoomsResponse.fromJson({'data': data});
    return ChatRoomsResponse.fromJson({});
  }

  @override
  Future<ChatRoomModel> createRoom({required int bookingId, required int userId, required int guardId}) async {
    final res = await dio.post(ApiConstants.chatStartRoom, data: {
      'booking_id': bookingId,
      'user_id': userId,
      'guard_id': guardId,
    });
    final data = res.data;
    Map<String, dynamic>? map;
    if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic>) {
        final inner = data['data'] as Map<String, dynamic>;
        // inner may contain room key
        if (inner['room'] is Map<String, dynamic>) map = inner['room'] as Map<String, dynamic>;
        else if (inner['id'] != null) map = inner;
        else if (inner['data'] is Map<String, dynamic>) map = inner['data'] as Map<String, dynamic>;
        else map = inner;
      } else if (data['room'] is Map<String, dynamic>) {
        map = data['room'] as Map<String, dynamic>;
      } else if (data['id'] != null) {
        map = data;
      }
    }
    if (map != null && map['id'] != null) {
      return ChatRoomModel.fromJson(map);
    }
    // if server returned success but no id, try to find any id in response
    if (data is Map<String, dynamic>) {
      // search recursively for id
      String? findId(dynamic obj) {
        if (obj is Map) {
          if (obj['id'] != null) return obj['id'].toString();
          for (final v in obj.values) {
            final r = findId(v);
            if (r != null) return r;
          }
        } else if (obj is List && obj.isNotEmpty) {
          return findId(obj.first);
        }
        return null;
      }
      final f = findId(data);
      if (f != null) {
        // create minimal room
        return ChatRoomModel(id: int.tryParse(f) ?? 0, bookingId: bookingId, name: 'Soor', guardId: guardId, userId: userId);
      }
    }
    throw DioException(requestOptions: res.requestOptions, response: res, error: 'Failed to parse room create response: $data');
  }

  @override
  Future<ChatMessagesResponse> getMessages({required int roomId, int perPage = 1000000}) async {
    final currentUserId = StorageHelper.getUser()?.id;
    final res = await dio.get(ApiConstants.chatMessages(roomId), queryParameters: {'per_page': perPage});
    final data = res.data;
    if (data is Map<String, dynamic>) return ChatMessagesResponse.fromJson(data, currentUserId: currentUserId);
    if (data is List) return ChatMessagesResponse.fromJson({'data': data}, currentUserId: currentUserId);
    return ChatMessagesResponse.fromJson({}, currentUserId: currentUserId);
  }

  @override
  Future<ChatMessageModel> sendMessage({required int roomId, required int bookingId, required int senderId, required String message}) async {
    final res = await dio.post(ApiConstants.chatMessages(roomId), data: {
      'booking_id': bookingId,
      'sender_id': senderId,
      'message': message,
    });
    final currentUserId = StorageHelper.getUser()?.id ?? senderId;
    final data = res.data;
    Map<String, dynamic>? map;
    if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic>) map = data['data'] as Map<String, dynamic>;
      else if (data['message'] is Map<String, dynamic>) map = data['message'] as Map<String, dynamic>;
      else if (data['data'] is Map && (data['data'] as Map)['message'] is Map) map = (data['data'] as Map)['message'] as Map<String, dynamic>;
      else if (data['id'] != null) map = data;
    }
    if (map != null && (map['id'] != null || map['message'] != null)) {
      return ChatMessageModel.fromJson(map, currentUserId: currentUserId);
    }
    // بعض السيرفرات ترجع {status:true, message:"تم الارسال"} بدون object -> نرجع optimistic لكن isMine true
    if (data is Map<String, dynamic> && (data['status'] == true || data['status'] == 1)) {
      return ChatMessageModel(id: DateTime.now().millisecondsSinceEpoch, roomId: roomId, senderId: senderId, message: message, isMine: true, createdAt: DateTime.now().toIso8601String());
    }
    throw DioException(requestOptions: res.requestOptions, response: res, error: 'Failed to parse send message response: $data');
  }
}
