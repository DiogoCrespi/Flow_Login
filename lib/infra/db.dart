import 'package:flowlogin/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserRepository{

  static late Future<Database> database;

  insert(User user) async {
    final db = await database;
      db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
      );
  }

  Future<User?> getUser(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return await User.fromMap(maps.first);
    }
    return null;
  }

  open() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'users.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id TEXT PRIMARY KEY, name TEXT, email TEXT, password TEXT)',
        );
      },
      version: 2
    );
  }

}