import 'package:ngiritlah/database/database_service.dart';
import 'package:sqflite/sqflite.dart';

import '../models/user.dart';

class UserDatabaseService {
  static Future<void> createTable() async {
    final database = await DatabaseService.initDb();
    await database.execute(
        "CREATE TABLE user (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, salary REAL, salary_balance REAL, created_date INTEGER)");
  }

  static Future<void> insert(String name, double salary) async {
    final database = await DatabaseService.initDb();
    var values = {
      'name': name,
      'salary': salary,
      'salary_balance': salary,
      'created_date': DateTime.now().millisecondsSinceEpoch
    };
    final insert = await database.insert('user', values,
        conflictAlgorithm: ConflictAlgorithm.fail);
    print("[InsertUser] $insert");
  }

  static Future<User> get() async {
    final database = await DatabaseService.initDb();
    List<Map<String, dynamic>> user =
        await database.rawQuery("SELECT * FROM user");
    return User.fromJson(user[0]);
  }
}
