import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB{
    Future<Database> open() async {
      
      return await openDatabase(
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