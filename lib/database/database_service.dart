import 'dart:convert';

import 'package:ngiritlah/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  // final BuildContext context;
  // DatabaseService(this.context);
  static Database? _database;

  static Future<String> getDbPath() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, 'ngiritlah.db');
    return path;
  }

  static Future<void> initDatabase() async {
    final dbPath = await getDbPath();
    _database = await openDatabase(dbPath, version: 1, onCreate: (db, version) {
      print("database `ngiritlah` created");
    });
  }

  static Future<Database> initDb() async {
    final dbPath = await getDbPath();
    final db = await openDatabase(dbPath, version: 1, onCreate: (db, version) {
      print("database `ngiritlah` created");
    });
    return db;
  }

  // static Future<void> createTableUser() async {
  //   if (_database == null) {
  //     await initDatabase();
  //   }
  //   await _database!.execute(
  //       "CREATE TABLE user (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, salary REAL, salary_balance REAL, created_date INTEGER)");
  // }

  // static Future<void> insertUser(String name, double salary) async {
  //   if (_database == null) {
  //     await initDatabase();
  //   }
  //   var values = {
  //     'name': name,
  //     'salary': salary,
  //     'salary_balance': salary,
  //     'created_date': DateTime.now().millisecondsSinceEpoch
  //   };
  //   final insert = await _database!
  //       .insert('user', values, conflictAlgorithm: ConflictAlgorithm.fail);
  //   print("[InsertUser] $insert");
  // }

  // static Future<User> getUser() async {
  //   if (_database == null) {
  //     await initDatabase();
  //   }
  //   List<Map<String, dynamic>> user =
  //       await _database!.rawQuery("SELECT * FROM user");
  //   return User.fromJson(user[0]);
  // }
}
