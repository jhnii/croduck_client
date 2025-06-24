import 'package:equatable/equatable.dart';

enum MessageSender {
  user,    // 사용자가 보낸 메시지
  bot,     // 봇이 보낸 메시지
  system,  // 시스템 메시지 (필요 시 사용)
}

class MessageEntity extends Equatable {
  final String id;
  final String content;
  final MessageSender sender;
  final DateTime createdAt;
  final MessageStatus status;

  const MessageEntity({
    required this.id,
    required this.content,
    required this.sender,
    required this.createdAt,
    required this.status,
  });

  @override
  List<Object?> get props => [id, content, sender, createdAt, status];
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  failed,
} 