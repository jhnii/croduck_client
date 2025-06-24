import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/get_messages_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';

part 'chat_event.dart';
part 'chat_state.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;

  ChatBloc(this.getMessagesUseCase, this.sendMessageUseCase) 
      : super(const ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatLoading());

    final result = await getMessagesUseCase();
    
    result.fold(
      (failure) => emit(ChatError(failure.toString())),
      (messages) => emit(ChatLoaded(messages)),
    );
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      
      // 사용자 메시지를 즉시 UI에 표시
      final userMessage = MessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: event.content,
        sender: MessageSender.user,
        createdAt: DateTime.now(),
        status: MessageStatus.sending,
      );

      // 사용자 메시지를 현재 메시지 리스트에 추가
      final messagesWithUser = [...currentState.messages, userMessage];
      emit(ChatLoaded(messagesWithUser));

      // 메시지 전송
      final result = await sendMessageUseCase(event.content);
      
      result.fold(
        (failure) {
          // 실패 시 사용자 메시지의 상태만 failed로 변경
          final updatedMessages = messagesWithUser.map((msg) {
            if (msg.id == userMessage.id) {
              return MessageEntity(
                id: msg.id,
                content: msg.content,
                sender: msg.sender,
                createdAt: msg.createdAt,
                status: MessageStatus.failed,
              );
            }
            return msg;
          }).toList();
          
          emit(ChatLoaded(updatedMessages));
        },
        (botResponse) {
          // 성공 시 사용자 메시지 상태를 sent로 변경하고 봇 응답 추가
          final updatedMessages = messagesWithUser.map((msg) {
            if (msg.id == userMessage.id) {
              return MessageEntity(
                id: msg.id,
                content: msg.content,
                sender: msg.sender,
                createdAt: msg.createdAt,
                status: MessageStatus.sent,
              );
            }
            return msg;
          }).toList();
          
          // 봇 응답을 마지막에 추가
          emit(ChatLoaded([...updatedMessages, botResponse]));
        },
      );
    }
  }
} 