import 'package:soor_app/features/chat/data/models/chat_models.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}
class ChatRoomsLoading extends ChatState {}
class ChatRoomsLoaded extends ChatState {
  final List<ChatRoomModel> rooms;
  ChatRoomsLoaded(this.rooms);
}
class ChatRoomsEmpty extends ChatState {}
class ChatRoomsError extends ChatState { final String message; ChatRoomsError(this.message); }
class ChatRoomCreating extends ChatState {}
class ChatRoomCreated extends ChatState { final ChatRoomModel room; ChatRoomCreated(this.room); }
class ChatMessagesLoading extends ChatState {}
class ChatMessagesLoaded extends ChatState { final List<ChatMessageModel> messages; ChatMessagesLoaded(this.messages); }
class ChatMessagesError extends ChatState { final String message; ChatMessagesError(this.message); }
class ChatSending extends ChatState {}
class ChatSent extends ChatState { final ChatMessageModel message; ChatSent(this.message); }
class ChatSendError extends ChatState { final String message; ChatSendError(this.message); }
