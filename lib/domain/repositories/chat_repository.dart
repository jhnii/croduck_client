import 'package:dartz/dartz.dart';
import '../entities/message_entity.dart';
import '../failures/failure.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<MessageEntity>>> getMessages();
  Future<Either<Failure, MessageEntity>> sendMessage(String content);
  Stream<Either<Failure, MessageEntity>> getMessageStream();
  Future<Either<Failure, void>> saveMessage(MessageEntity message);
} 