import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // 외부 의존성 등록
  getIt.registerLazySingleton<Dio>(() => Dio());
  
  // 데이터베이스 등록
  getIt.registerSingletonAsync<Database>(() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'chat.db');
    
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE messages(id TEXT PRIMARY KEY, content TEXT, sender INTEGER, createdAt TEXT, status INTEGER)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('DROP TABLE IF EXISTS messages');
          await db.execute(
            'CREATE TABLE messages(id TEXT PRIMARY KEY, content TEXT, sender INTEGER, createdAt TEXT, status INTEGER)',
          );
        }
      },
    );
  });

  await getIt.allReady();
  getIt.init();
} 