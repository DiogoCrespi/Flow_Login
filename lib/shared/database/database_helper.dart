import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'db_adapter.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  final DbAdapter _dbAdapter = DbAdapter();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      final dbPath = await _dbAdapter.getDatabasesPath();
      final path = join(dbPath, 'flowlogin.db');

      // Garante que o diretório existe
      await Directory(dirname(path)).create(recursive: true);

      return await openDatabase(
        path,
        version: 2,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onOpen: (db) async {
          // Verifica se a tabela settings existe
          final tables = await db.query('sqlite_master',
              where: 'type = ? AND name = ?', whereArgs: ['table', 'settings']);
          if (tables.isEmpty) {
            await db.insert('settings', {'theme_mode': 'system'});
          }
        },
      );
    } catch (e) {
      print('Erro ao inicializar banco de dados: $e');
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
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

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Adiciona a coluna created_at à tabela users
      await db.execute(
          'ALTER TABLE users ADD COLUMN created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP');
    }
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    try {
      final db = await database;
      return await db.insert('users', user);
    } catch (e) {
      print('Erro ao inserir usuário: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final db = await database;
      return await db.query('users');
    } catch (e) {
      print('Erro ao buscar usuário: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );
      if (maps.isNotEmpty) {
        return maps.first;
      }
      return null;
    } catch (e) {
      print('Erro ao buscar usuário por email: $e');
      rethrow;
    }
  }

  Future<int> updateUser(Map<String, dynamic> user) async {
    try {
      final db = await database;
      return await db.update(
        'users',
        user,
        where: 'id = ?',
        whereArgs: [user['id']],
      );
    } catch (e) {
      print('Erro ao atualizar usuário: $e');
      rethrow;
    }
  }

  Future<int> deleteUser(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Erro ao deletar usuário: $e');
      rethrow;
    }
  }

  Future<int> updateSettings(Map<String, dynamic> settings) async {
    try {
      final db = await database;
      return await db.update(
        'settings',
        settings,
        where: 'id = ?',
        whereArgs: [1],
      );
    } catch (e) {
      print('Erro ao atualizar configurações: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getSettings() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('settings');
      if (maps.isNotEmpty) {
        return maps.first;
      }
      return null;
    } catch (e) {
      print('Erro ao buscar configurações: $e');
      rethrow;
    }
  }
}
