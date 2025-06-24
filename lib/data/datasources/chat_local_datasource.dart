import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import '../models/message_model.dart';

abstract class ChatLocalDataSource {
  Future<List<MessageModel>> getCachedMessages();
  Future<void> cacheMessage(MessageModel message);
  Future<void> clearCache();
}

@Injectable(as: ChatLocalDataSource)
class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final Database database;

  ChatLocalDataSourceImpl(this.database);

  @override
  Future<List<MessageModel>> getCachedMessages() async {
    try {
      final List<Map<String, dynamic>> maps = await database.query(
        'messages',
        orderBy: 'createdAt ASC',
      );

      return List.generate(maps.length, (i) {
        return MessageModel.fromSqliteMap(maps[i]);
      });
    } catch (e) {
      throw Exception('캐시된 메시지 조회 실패: $e');
    }
  }

  @override
  Future<void> cacheMessage(MessageModel message) async {
    try {
      await database.insert(
        'messages',
        message.toSqliteMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('메시지 캐시 저장 실패: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await database.delete('messages');
    } catch (e) {
      throw Exception('캐시 삭제 실패: $e');
    }
  }
} 