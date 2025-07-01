import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/failures/failure.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../infrastructure/data/models/message_model.dart';
import '../../infrastructure/data/local/chat_local_datasource.dart';
import '../../infrastructure/data/remote/chat_remote_datasource.dart';

@Injectable(as: ChatRepository)
class ChatPersistence implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatLocalDataSource localDataSource;

  ChatPersistence(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages() async {
    try {
      // 먼저 로컬 캐시에서 메시지 가져오기
      final localMessages = await localDataSource.getCachedMessages();
      
      if (localMessages.isNotEmpty) {
        return Right(localMessages.map((model) => model.toEntity()).toList());
      }

      // 로컬에 없으면 원격에서 가져오기
      final remoteMessages = await remoteDataSource.getMessages();
      
      // 로컬에 캐시
      for (final message in remoteMessages) {
        await localDataSource.cacheMessage(message);
      }

      return Right(remoteMessages.map((model) => model.toEntity()).toList());
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage(String content) async {
    try {
      // 사용자 메시지를 먼저 저장
      final userMessage = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        sender: MessageSender.user,
        createdAt: DateTime.now(),
        status: MessageStatus.sent,
      );

      await localDataSource.cacheMessage(userMessage);

      // 원격으로 메시지 전송하고 응답 받기
      final botResponse = await remoteDataSource.sendMessage(content);
      
      // 봇 응답도 로컬에 저장
      await localDataSource.cacheMessage(botResponse);

      return Right(botResponse.toEntity());
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveMessage(MessageEntity message) async {
    try {
      final messageModel = MessageModel.fromEntity(message);
      await localDataSource.cacheMessage(messageModel);
      return const Right(null);
    } on Exception catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, MessageEntity>> getMessageStream() {
    try {
      return remoteDataSource.getMessageStream().map(
        (message) => Right(message.toEntity()),
      );
    } catch (e) {
      return Stream.value(Left(NetworkFailure(e.toString())));
    }
  }
} 