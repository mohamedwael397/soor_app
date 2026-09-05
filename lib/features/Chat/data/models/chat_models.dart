class ChatRoomModel {
  final int id;
  final int? bookingId;
  final String? name;
  final String? lastMessage;
  final String? lastMessageTime;
  final int? unreadCount;
  final String? image;
  final int? guardId;
  final int? userId;

  ChatRoomModel({
    required this.id,
    this.bookingId,
    this.name,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount,
    this.image,
    this.guardId,
    this.userId,
  });

  static int _toInt(dynamic v) {
    if (v is int) return v;
    if (v == null) return 0;
    return int.tryParse('$v') ?? 0;
  }

  static String? _str(dynamic v) => v == null ? null : v.toString();

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    // handle nested wrappers like {booking:{id:..}} or {guard:{id:..}}
    int? bookingId;
    final rawBookingId = json['booking_id'] ?? json['bookingId'] ?? json['booking']?['id'] ?? json['order_id'];
    if (rawBookingId != null) bookingId = _toInt(rawBookingId);

    int? guardId;
    final rawGuard = json['guard_id'] ?? json['guardId'] ?? json['guard']?['id'];
    if (rawGuard != null) guardId = _toInt(rawGuard);

    int? userId;
    final rawUser = json['user_id'] ?? json['userId'] ?? json['user']?['id'];
    if (rawUser != null) userId = _toInt(rawUser);

    final name = _str(json['name'] ?? json['guard_name'] ?? json['guard']?['name'] ?? json['user_name'] ?? json['room_name'] ?? 'Soor');
    String? lastMsg = _str(json['last_message'] ?? json['last_msg'] ?? json['message'] ?? json['lastMessage']);
    if (lastMsg != null && lastMsg.isEmpty) lastMsg = null;
    // if last_message is object {body: ...}
    if (lastMsg == null && json['last_message'] is Map) {
      lastMsg = _str((json['last_message'] as Map)['body'] ?? (json['last_message'] as Map)['message']);
    }

    String? time = _str(json['last_message_time'] ?? json['last_message_at'] ?? json['updated_at'] ?? json['created_at'] ?? json['time']);
    int unread = 0;
    if (json['unread_count'] != null) unread = _toInt(json['unread_count']);
    if (json['unread'] != null) unread = _toInt(json['unread']);

    return ChatRoomModel(
      id: _toInt(json['id'] ?? json['room_id'] ?? json['chat_room_id']),
      bookingId: bookingId,
      guardId: guardId,
      userId: userId,
      name: name,
      lastMessage: lastMsg,
      lastMessageTime: time,
      unreadCount: unread,
      image: _str(json['image'] ?? json['avatar'] ?? json['guard_image'] ?? json['guard']?['image']),
    );
  }
}

class ChatMessageModel {
  final int id;
  final int? roomId;
  final int? senderId;
  final String message;
  final String? senderName;
  final String? createdAt;
  final bool isMine;

  ChatMessageModel({
    required this.id,
    this.roomId,
    this.senderId,
    required this.message,
    this.senderName,
    this.createdAt,
    required this.isMine,
  });

  static int _toInt(dynamic v) {
    if (v is int) return v;
    if (v == null) return 0;
    return int.tryParse('$v') ?? 0;
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json, {int? currentUserId}) {
    int _id(dynamic v) => _toInt(v);
    final sender = json['sender_id'] == null ? (json['user_id'] == null ? null : _id(json['user_id'])) : _id(json['sender_id']);
    // sender may be nested {sender:{id:..}}
    int? sender2;
    if (sender == null && json['sender'] is Map) {
      sender2 = _id((json['sender'] as Map)['id']);
    }
    final finalSender = sender ?? sender2;
    String msg = (json['message'] ?? json['msg'] ?? json['body'] ?? json['text'] ?? '').toString();
    if (msg.isEmpty && json['content'] != null) msg = json['content'].toString();
    String name = (json['sender_name'] ?? json['sender']?['name'] ?? json['user']?['name'] ?? '').toString();
    String time = (json['created_at'] ?? json['time'] ?? json['createdAt'] ?? json['date'] ?? '').toString();
    bool isMine;
    if (currentUserId != null && finalSender != null) {
      isMine = finalSender == currentUserId;
    } else {
      // fallback heuristic: if sender_name matches current user name treat as mine
      isMine = json['is_mine'] == true || json['isMine'] == true || json['is_sender'] == true;
    }
    return ChatMessageModel(
      id: _id(json['id'] ?? json['message_id'] ?? json['msg_id']),
      roomId: json['room_id'] == null ? (json['chat_room_id'] == null ? null : _id(json['chat_room_id'])) : _id(json['room_id']),
      senderId: finalSender,
      message: msg,
      senderName: name.isEmpty ? null : name,
      createdAt: time.isEmpty ? null : time,
      isMine: isMine,
    );
  }
}

class ChatRoomsResponse {
  final List<ChatRoomModel> rooms;
  ChatRoomsResponse(this.rooms);
  factory ChatRoomsResponse.fromJson(Map<String, dynamic> json) {
    List<ChatRoomModel> list = [];
    dynamic data = json['data'];
    // case 1: data is List
    if (data is List) {
      list = data.map((e) => ChatRoomModel.fromJson(e as Map<String, dynamic>)).toList();
    } else if (data is Map && data['data'] is List) {
      list = (data['data'] as List).map((e) => ChatRoomModel.fromJson(e as Map<String, dynamic>)).toList();
    } else if (data is Map && data['rooms'] is List) {
      list = (data['rooms'] as List).map((e) => ChatRoomModel.fromJson(e as Map<String, dynamic>)).toList();
    } else if (json['rooms'] is List) {
      list = (json['rooms'] as List).map((e) => ChatRoomModel.fromJson(e as Map<String, dynamic>)).toList();
    } else if (json['data'] is List && data == null) {
      // already handled
    } else if (data is Map && data['data'] is Map && data['data']['data'] is List) {
      list = (data['data']['data'] as List).map((e) => ChatRoomModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    // also handle paginated wrapper at root: {current_page, data:[...]}
    if (list.isEmpty && json['data'] is Map && (json['data'] as Map)['data'] is List) {
      // already
    }
    return ChatRoomsResponse(list);
  }
}

class ChatMessagesResponse {
  final List<ChatMessageModel> messages;
  ChatMessagesResponse(this.messages);
  factory ChatMessagesResponse.fromJson(Map<String, dynamic> json, {int? currentUserId}) {
    List<ChatMessageModel> list = [];
    dynamic data = json['data'];
    if (data is List) {
      list = data.map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>, currentUserId: currentUserId)).toList();
    } else if (data is Map && data['data'] is List) {
      list = (data['data'] as List).map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>, currentUserId: currentUserId)).toList();
    } else if (data is Map && data['messages'] is List) {
      list = (data['messages'] as List).map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>, currentUserId: currentUserId)).toList();
    } else if (json['messages'] is List) {
      list = (json['messages'] as List).map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>, currentUserId: currentUserId)).toList();
    } else if (json['data'] is Map && (json['data'] as Map)['messages'] is List) {
      list = ((json['data'] as Map)['messages'] as List).map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>, currentUserId: currentUserId)).toList();
    }
    return ChatMessagesResponse(list);
  }
}
