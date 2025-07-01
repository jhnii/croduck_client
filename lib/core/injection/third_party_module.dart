import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

@module
abstract class ThirdPartyModule {
  @preResolve
  Future<Database> get database async {
    return openDatabase(
      join(await getDatabasesPath(), 'chat_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE messages(id TEXT PRIMARY KEY, content TEXT, sender TEXT, createdAt TEXT, status TEXT)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute('DROP TABLE IF EXISTS messages');
          db.execute(
            'CREATE TABLE messages(id TEXT PRIMARY KEY, content TEXT, sender TEXT, createdAt TEXT, status TEXT)',
          );
        }
      },
      version: 2,
    );
  }

  @lazySingleton
  Dio get dio => Dio();
} 