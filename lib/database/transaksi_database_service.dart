import 'package:ngiritlah/database/kategori_database_service.dart';
import 'package:ngiritlah/models/transaksi.dart';
import 'package:sqflite/sqflite.dart';

import '../models/kategori.dart';
import 'database_service.dart';

class TransaksiDatabaseService {
  static Future<void> createTable() async {
    final database = await DatabaseService.initDb();
    await database.execute(
        "CREATE TABLE transaksi (id INTEGER PRIMARY KEY AUTOINCREMENT, id_kategori INTEGER, keterangan TEXT, type INTEGER, nominal REAL, created_date INTEGER)");
  }

  static Future<bool> insert(Transaksi transaksi, Kategori kategori) async {
    final database = await DatabaseService.initDb();
    // final insert = await database.insert('transaksi', transaksi.toJson(),
    //     conflictAlgorithm: ConflictAlgorithm.fail);
    bool success1 = false;
    bool success2 = false;
    final trx = await database.transaction((txn) async {
      final insertTrx = await txn.rawInsert(
          'INSERT INTO transaksi (id_kategori, keterangan, nominal, created_date) VALUES (${transaksi.idKategori}, "${transaksi.keterangan}", ${transaksi.nominal}, ${transaksi.createdDate!.millisecondsSinceEpoch}) ');
      print("[Insert Transaction] $insertTrx");
      success1 = insertTrx > 0;
      var amount = kategori.balance! - (transaksi.nominal ?? 0);
      final updateKategoriBalance = await txn.rawUpdate(
          "UPDATE kategori SET balance=? WHERE id=?", [amount, kategori.id]);
      success2 = updateKategoriBalance > 0;
      print("[Update Kategori Balance] $updateKategoriBalance");
    });

    return (success1 && success2);
  }

  static Future<List<Transaksi>> get() async {
    final database = await DatabaseService.initDb();
    final items =
        await database.rawQuery("SELECT * FROM transaksi ORDER BY id");
    return items.map((e) => Transaksi.fromJson(e)).toList();
  }
}
