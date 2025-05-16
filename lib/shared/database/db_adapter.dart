import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

class DbAdapter {
  static final DbAdapter _instance = DbAdapter._internal();
  static dynamic _database;

  factory DbAdapter() => _instance;

  DbAdapter._internal();

  Future<dynamic> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<String> getDatabasesPath() async {
    // Desktop/Mobile: usar o diretório de documentos
    final appDir = await getApplicationDocumentsDirectory();
    return appDir.path;
  }

  Future<dynamic> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'flowlogin.db');
    return await sqflite.openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onOpen: (db) async {
        final tables = await db.query('sqlite_master',
            where: 'type = ? AND name = ?', whereArgs: ['table', 'settings']);
        if (tables.isEmpty) {
          await db.insert('settings', {'theme_mode': 'system'});
        }
      },
    );
  }

  Future<void> _onCreate(sqflite.Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        theme_mode TEXT NOT NULL
      )
    ''');
  }
}
