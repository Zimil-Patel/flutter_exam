import 'dart:developer';

import 'package:flutter_exam/model/contact_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DbServices {
  DbServices._();

  // single tone object
  static DbServices dbServices = DbServices._();

  Database? _database;
  static final tableName = 'contacts';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await createDatabase();
      return _database!;
    }
  }

  Future<Database> createDatabase() async {
    final filePath = await getDatabasesPath();
    final dbPath = path.join(filePath, 'myDb.db');

    // initializing database
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
            CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            phone TEXT,
            email TEXT,
            category TEXT,
            isFavourite INTEGER
            )
          ''');
      },
    );
  }

  // insert
  Future<void> insertRecord(Contact contact) async {
    final db = await database;
    try {
      final result = await db.insert(
        tableName,
        Contact.toMap(contact),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      if (result == 1) {
        log("INSERTED");
      } else {
        log("FAILED");
      }
    } catch (e) {
      log("$e----------------------");
    }
  }

  // update
  Future<void> updateRecord(Contact contact) async {
    final db = await database;
    try {
      final result = await db.update(
        tableName,
        Contact.toMap(contact),
        where: 'id = ?',
        whereArgs: [contact.id],
      );
      if (result == 1) {
        log("UPDATED");
      } else {
        log("FAILED");
      }
    } catch (e) {
      log("$e----------------------");
    }
  }

  // delete
  Future<void> deleteRecord(int id) async {
    final db = await database;
    try {
      final result = await db.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      if (result == 1) {
        log("DELETE");
      } else {
        log("FAILED");
      }
    } catch (e) {
      log("$e----------------------");
    }
  }

  // real all
  Future<List<Map<String, Object?>>> readAllRecords() async {
    final db = await database;
    return await db.query(tableName);
  }

  // filter by category
  Future<List<Map<String, Object?>>> getByCategory(String category) async {
    final db = await database;
    return await db.query(
      tableName,
      where: 'category LIKE ?',
      whereArgs: [category],
    );
  }

  // sort by favourite
  Future<List<Map<String, Object?>>> getByFavourites() async {
    final db = await database;
    return await db.query(
      tableName,
      orderBy: 'isFavourite DESC',
    );
  }
}
