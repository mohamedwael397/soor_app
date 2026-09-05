import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:soor_app/core/error/failure.dart';
import 'package:soor_app/features/chat/data/datasource/chat_remote_datasource.dart';
import 'package:soor_app/features/chat/data/models/chat_models.dart';

abstract class ChatRepository {
  Future<Either<Failure, ChatRoomsResponse>> getRooms();
  Future<Either<Failure, ChatRoomModel>> createRoom({required int bookingId, required int userId, required int guardId});
  Future<Either<Failure, ChatMessagesResponse>> getMessages({required int roomId});
  Future<Either<Failure, ChatMessageModel>> sendMessage({required int roomId, required int bookingId, required int senderId, required String message});
}

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remote;
  ChatRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, ChatRoomsResponse>> getRooms() async {
    try {
      final res = await remote.getChatRooms();
      return Right(res);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatRoomModel>> createRoom({required int bookingId, required int userId, required int guardId}) async {
    try {
      final res = await remote.createRoom(bookingId: bookingId, userId: userId, guardId: guardId);
      return Right(res);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatMessagesResponse>> getMessages({required int roomId}) async {
    try {
      final res = await remote.getMessages(roomId: roomId);
      return Right(res);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatMessageModel>> sendMessage({required int roomId, required int bookingId, required int senderId, required String message}) async {
    try {
      final res = await remote.sendMessage(roomId: roomId, bookingId: bookingId, senderId: senderId, message: message);
      return Right(res);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
