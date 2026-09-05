import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soor_app/features/chat/data/repo/chat_repository.dart';
import 'package:soor_app/features/chat/data/models/chat_models.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repo;
  ChatCubit(this.repo) : super(ChatInitial());

  List<ChatRoomModel> _rooms = [];
  List<ChatMessageModel> _messages = [];
  int? _currentRoomId;

  List<ChatRoomModel> get rooms => _rooms;
  List<ChatMessageModel> get messages => _messages;
  int? get currentRoomId => _currentRoomId;

  Future<void> fetchRooms() async {
    emit(ChatRoomsLoading());
    final res = await repo.getRooms();
    res.fold(
      (l) => emit(ChatRoomsError(l.message)),
      (r) {
        _rooms = r.rooms;
        if (_rooms.isEmpty) emit(ChatRoomsEmpty());
        else emit(ChatRoomsLoaded(List.from(_rooms)));
      },
    );
  }

  Future<void> createRoom({required int bookingId, required int userId, required int guardId}) async {
    emit(ChatRoomCreating());
    // حاول أولاً لو فيه غرفة موجودة لنفس الحجز استخدمها لتجنب تكرار
    final existing = _rooms.where((r) => r.bookingId == bookingId).toList();
    if (existing.isNotEmpty) {
      emit(ChatRoomCreated(existing.first));
      return;
    }
    final res = await repo.createRoom(bookingId: bookingId, userId: userId, guardId: guardId);
    res.fold(
      (l) => emit(ChatRoomsError(l.message)),
      (room) {
        if (room.id == 0) {
          emit(ChatRoomsError('فشل إنشاء غرفة المحادثة - استجابة غير متوقعة من السيرفر'));
          return;
        }
        if (!_rooms.any((e) => e.id == room.id)) _rooms.insert(0, room);
        emit(ChatRoomCreated(room));
        // لا نعمل emit loaded مباشرة عشان الـ listener في BookingDetails يلتقط Created
        // المستمع سيتنقل للشات، والـ ChatHistory سيعمل fetchRooms لاحقاً
      },
    );
  }

  Future<void> fetchMessages(int roomId) async {
    _currentRoomId = roomId;
    emit(ChatMessagesLoading());
    final res = await repo.getMessages(roomId: roomId);
    res.fold(
      (l) => emit(ChatMessagesError(l.message)),
      (r) {
        _messages = r.messages;
        emit(ChatMessagesLoaded(List.from(_messages)));
      },
    );
  }

  Future<void> sendMessage({required int roomId, required int bookingId, required int senderId, required String message}) async {
    if (message.trim().isEmpty) return;
    // optimistic add
    final temp = ChatMessageModel(id: DateTime.now().millisecondsSinceEpoch, message: message, isMine: true, createdAt: DateTime.now().toIso8601String());
    _messages.add(temp);
    emit(ChatMessagesLoaded(List.from(_messages)));
    emit(ChatSending());
    final res = await repo.sendMessage(roomId: roomId, bookingId: bookingId, senderId: senderId, message: message);
    res.fold(
      (l) {
        // remove optimistic on fail
        _messages.remove(temp);
        emit(ChatSendError(l.message));
        emit(ChatMessagesLoaded(List.from(_messages)));
      },
      (msg) {
        // replace last optimistic with real
        _messages.remove(temp);
        _messages.add(msg);
        emit(ChatSent(msg));
        emit(ChatMessagesLoaded(List.from(_messages)));
      },
    );
  }

  void clearMessages() {
    _messages = [];
    _currentRoomId = null;
  }
}
