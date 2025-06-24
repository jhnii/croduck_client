import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/message_entity.dart';
import '../failures/failure.dart';
import '../repositories/chat_repository.dart';

@injectable
class SendMessageUseCase {
  final ChatRepository repository;

  const SendMessageUseCase(this.repository);

  Future<Either<Failure, MessageEntity>> call(String content) async {
    if (content.trim().isEmpty) {
      return const Left(ServerFailure('메시지 내용이 비어있습니다'));
    }

    return await repository.sendMessage(content.trim());
  }
} 