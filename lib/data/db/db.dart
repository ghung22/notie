import 'package:sqflite/sqflite.dart';

class Db {
  static const dbName = 'notie';
  static const dbVersion = 1;

  static const notesTable = 'notes';
  static const notesTableCreateStatement = '''
    CREATE TABLE $notesTable (
      title TEXT NOT NULL DEFAULT '',
      content TEXT NOT NULL DEFAULT '',
      path TEXT NOT NULL DEFAULT '',
      colorHex INTEGER,
      createdTimestamp INTEGER PRIMARY KEY NOT NULL,
      updatedTimestamp INTEGER NOT NULL DEFAULT 0,
      deletedTimestamp INTEGER NOT NULL DEFAULT 0
    );
  ''';

  static Database? _db;

  static Future<Database> db() async {
    await open();
    return _db!;
  }

  static Future<void> open() async {
    _db ??= await openDatabase(
      dbName,
      version: dbVersion,
      onCreate: (Database db, int version) async {
        await db.execute(notesTableCreateStatement);
      });
  }

  static void close() {
    _db?.close();
    _db = null;
  }
}