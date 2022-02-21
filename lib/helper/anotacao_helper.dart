import 'package:notes/model/notes.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class AnotacaoHelper {
  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();

  Database? _db;

  factory AnotacaoHelper() {
    return _anotacaoHelper;
  }
  AnotacaoHelper._internal() {}

  get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await inicializarDB();
      return _db;
    }
  }

  _onCreate(Database db, int version) async {
    String sql =
        "CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT,titulo VARCHAR,descricao TEXT,data DATETIME)";
    await db.execute(sql);
  }

  inicializarDB() async {
    var caminhoBD = await getDatabasesPath();
    String localDB = join(caminhoBD, "mynotes.db");
    Database db = await openDatabase(localDB, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<int?> salvarNote(Notes notes) async {
    var bancoDB = await db;
    Map<String, dynamic> map = {
      "titulo": notes.titulo,
      "descricao": notes.descricao,
      "data": notes.data
    };
    int? id = await bancoDB?.insert("notes", map);
    return id;
  }

  recuperarNotes() async {
    var bancoDB = await db;
    String sql = "SELECT * FROM notes ORDER BY  data DESC";
    List? anotacoes = await bancoDB?.rawQuery(sql);
    return anotacoes;
  }
}