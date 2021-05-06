import 'dart:convert';

import 'package:noti/models/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class NoteDatabase{
  static final NoteDatabase instance = NoteDatabase._init();
  NoteDatabase._init();
  static Database _database;
  Future<Database> get database async{
    if(_database != null) return _database ;
    _database = await _initDB('notes.db');
    return database;
  }
  Future<Database> _initDB(String filePath)async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath , filePath);
    return await openDatabase(path,version: 1,onCreate: _onCreateDb);
  }
  Future _onCreateDb(Database dBase , int version)async{
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final intType = 'INTEGER NOT NULL';
    await dBase.execute('''
    CREATE TABLE $tableNotes (
    ${NoteFields.id} $idType,
    ${NoteFields.isImportant} $boolType,
    ${NoteFields.number} $intType,
    ${NoteFields.title} $textType,
    ${NoteFields.description} $textType,
    ${NoteFields.time} $textType
    )
    ''');
  }
Future<Note> create(Note note) async{
    final db = await instance.database;
    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }
  Future<Note> readNote(int id)async{
    final db = await instance.database;
    final maps =await db.query(
      tableNotes,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
     if(maps.isNotEmpty){
       return Note.fromJson(maps.first);
     }else{
       throw Exception('ID $id not found');
     }
  }
  Future<List<Note>> readAllNotes()async{
    final db = await instance.database;
    final orderBy = '${NoteFields.time} ASC';
    final result =await  db.query(tableNotes, orderBy: orderBy);
    return result.map((json)=>Note.fromJson(json)).toList();
  }
  Future<int> updateNote(Note note)async{
    final db = await instance.database;
    return db.update(tableNotes, note.toJson(),where: '${NoteFields.id}=?', whereArgs: [note.id]);
  }
  Future<int> delete(int id)async{
    final db = await instance.database;
    return db.delete(tableNotes,
     where: '${NoteFields.id} = ?',
      whereArgs: [id]
    );
  }
  Future close()async{
    final db = await instance.database;
    db.close();
  }
}