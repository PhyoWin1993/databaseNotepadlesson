import 'dart:async';
import 'dart:io';

import 'package:notepad/model/notedoitem.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  final String notetable = "notetable";
  final String coulmnId = "id";
  final String itemname = "itemname";
  final String datecreate = "datecreate";

  static final DatabaseHelper _inst = new DatabaseHelper.internal();

  factory DatabaseHelper() => _inst;
  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await _initDb();
    return _db;
  }

  DatabaseHelper.internal();

  _initDb() async {
    Directory pa = await getApplicationDocumentsDirectory();
    String path = join(pa.path, "notepad.db");

    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $notetable($coulmnId INTEGER PRIMARY KEY,$itemname TEXT,$datecreate TEXT)");
  }

  // Database Connection

  Future<int> saveData(NoDoItem notodo) async {
    var dbClien = await db;
    int res = await dbClien.insert(notetable, notodo.toMap());
    return res;
  }

  Future<List> getAlldata() async {
    var dbClien = await db;
    var res = await dbClien
        .rawQuery("SELECT * FROM $notetable"); // ordery by $column ASC
    return res.toList();
  }

  Future<int> getCount() async {
    var dbClien = await db;

    return Sqflite.firstIntValue(
        await dbClien.rawQuery("SELECT COUNT(*) FROM $notetable"));
  }

  Future<NoDoItem> getOneData(int id) async {
    var dbClien = await db;
    var res =
        await dbClien.rawQuery("SELECT * FROM $notetable WHERE $coulmnId=$id");
    if (res.length == 0) return null;

    return new NoDoItem.fromMap(res.first);
  }

  Future<int> updateData(NoDoItem notodo) async {
    var dbClien = await db;
    int res = await dbClien.update(notetable, notodo.toMap(),
        where: "$coulmnId=?", whereArgs: [notodo.id]);
    return res;
  }

  Future<int> deleteData(int id) async {
    var dbClien = await db;
    int res =
        await dbClien.delete(notetable, where: "$coulmnId=?", whereArgs: [id]);
    return res;
  }

  Future closeDbf() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
