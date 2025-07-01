import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/failures/failure.dart';
import '../../domain/repositories/chat_repository.dart';

@injectable
class GetMessagesUseCase {
  final ChatRepository repository;

  const GetMessagesUseCase(this.repository);

  Future<Either<Failure, List<MessageEntity>>> call() async {
    return await repository.getMessages();
  }
} 