part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadMessages extends ChatEvent {
  const LoadMessages();
}

class SendMessage extends ChatEvent {
  final String content;

  const SendMessage(this.content);

  @override
  List<Object> get props => [content];
} 