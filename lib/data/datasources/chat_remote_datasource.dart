import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/message_model.dart';
import '../../domain/entities/message_entity.dart';

abstract class ChatRemoteDataSource {
  Future<MessageModel> sendMessage(String content);
  Future<List<MessageModel>> getMessages();
  Stream<MessageModel> getMessageStream();
}

@Injectable(as: ChatRemoteDataSource)
class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio dio;

  ChatRemoteDataSourceImpl(this.dio);

  @override
  Future<MessageModel> sendMessage(String content) async {
    try {
      // 실제로는 서버 API 호출
      // 현재는 모의 응답 생성
      await Future.delayed(const Duration(milliseconds: 500));
      
      return MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: _generateBotResponse(content),
        sender: MessageSender.bot,
        createdAt: DateTime.now(),
        status: MessageStatus.sent,
      );
    } catch (e) {
      throw Exception('메시지 전송 실패: $e');
    }
  }

  @override
  Future<List<MessageModel>> getMessages() async {
    try {
      // 실제로는 서버에서 메시지 목록 가져오기
      await Future.delayed(const Duration(milliseconds: 300));
      return [];
    } catch (e) {
      throw Exception('메시지 조회 실패: $e');
    }
  }

  @override
  Stream<MessageModel> getMessageStream() {
    // 실제로는 WebSocket 또는 Server-Sent Events 연결
    return Stream.empty();
  }

  String _generateBotResponse(String userMessage) {
    final responses = [
      "좋은 질문이네요! 제가 도움을 드릴 수 있어 기쁩니다.",
      "흥미로운 주제입니다. 더 자세히 설명해 드릴까요?",
      "네, 알겠습니다. 다른 궁금한 점이 있으시면 언제든 말씀해 주세요.",
      "정말 좋은 아이디어네요! 이런 관점으로 생각해 볼 수도 있을 것 같아요.",
      "네, 맞습니다. 이 주제에 대해 더 깊이 들어가 보시죠.",
      "도움이 되었기를 바랍니다. 추가로 궁금한 것이 있으시면 말씀해 주세요!",
    ];
    
    return responses[userMessage.hashCode % responses.length];
  }
} 