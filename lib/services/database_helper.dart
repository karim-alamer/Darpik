import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<void> initDb() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'darbuk.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  static Future<int> registerUser(Map<String, dynamic> user) async {
    return await _database!.insert('users', user);
  }

  static Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final List<Map<String, dynamic>> result = await _database!.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty ? result.first : null;
  }
}