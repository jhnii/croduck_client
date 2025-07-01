// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
  id: json['id'] as String,
  content: json['content'] as String,
  sender: $enumDecode(_$MessageSenderEnumMap, json['sender']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  status: $enumDecode(_$MessageStatusEnumMap, json['status']),
);

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'sender': _$MessageSenderEnumMap[instance.sender]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'status': _$MessageStatusEnumMap[instance.status]!,
    };

const _$MessageSenderEnumMap = {
  MessageSender.user: 'user',
  MessageSender.bot: 'bot',
  MessageSender.system: 'system',
};

const _$MessageStatusEnumMap = {
  MessageStatus.sending: 'sending',
  MessageStatus.sent: 'sent',
  MessageStatus.delivered: 'delivered',
  MessageStatus.failed: 'failed',
};
