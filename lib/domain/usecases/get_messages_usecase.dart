import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/message_entity.dart';
import '../failures/failure.dart';
import '../repositories/chat_repository.dart';

@injectable
class GetMessagesUseCase {
  final ChatRepository repository;

  const GetMessagesUseCase(this.repository);

  Future<Either<Failure, List<MessageEntity>>> call() async {
    return await repository.getMessages();
  }
} 