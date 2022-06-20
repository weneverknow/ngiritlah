import 'package:flutter/rendering.dart';
import 'package:ngiritlah/database/database_service.dart';
import 'package:ngiritlah/models/kategori.dart';
import 'package:sqflite/sqflite.dart';

class KategoriDatabaseService {
  static Future<void> createTable() async {
    final database = await DatabaseService.initDb();
    await database.execute(
        "CREATE TABLE kategori (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, nominal REAL, balance REAL)");
  }

  static Future<int> insert(Kategori kategori) async {
    final database = await DatabaseService.initDb();
    final insert = await database.insert('kategori', kategori.toJson(),
        conflictAlgorithm: ConflictAlgorithm.fail);
    return insert;
  }

  static Future<List<Kategori>?> get() async {
    final database = await DatabaseService.initDb();
    final items = await database.rawQuery("SELECT * FROM kategori ORDER BY id");
    if (items.isEmpty) {
      return [];
    }
    return items.map((e) => Kategori.fromJson(e)).toList();
  }

  static Future<int> updateBalance(
      Kategori kategori, double nominalTransaksi) async {
    final database = await DatabaseService.initDb();
    var amount = kategori.balance! - nominalTransaksi;
    final update = await database.rawUpdate(
        "UPDATE kategori SET balance=? WHERE id=?", [amount, kategori.id]);
    return update;
  }
}
