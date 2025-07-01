import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/message_entity.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.content,
    required super.sender,
    required super.createdAt,
    required super.status,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  // SQLite 호환성을 위한 변환 메서드
  Map<String, dynamic> toSqliteMap() {
    return {
      'id': id,
      'content': content,
      'sender': sender.index, // enum을 int로 변환
      'createdAt': createdAt.toIso8601String(),
      'status': status.index, // enum을 int로 변환
    };
  }

  factory MessageModel.fromSqliteMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'],
      content: map['content'],
      sender: MessageSender.values[map['sender']], // int를 enum으로 변환
      createdAt: DateTime.parse(map['createdAt']),
      status: MessageStatus.values[map['status']], // int를 enum으로 변환
    );
  }

  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel(
      id: entity.id,
      content: entity.content,
      sender: entity.sender,
      createdAt: entity.createdAt,
      status: entity.status,
    );
  }

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      content: content,
      sender: sender,
      createdAt: createdAt,
      status: status,
    );
  }
} 