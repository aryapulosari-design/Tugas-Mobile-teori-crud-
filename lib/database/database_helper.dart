import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/mahasiswa.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mahasiswa.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE mahasiswa (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nim TEXT NOT NULL UNIQUE,
        nama TEXT NOT NULL,
        prodi TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertMahasiswa(Mahasiswa mahasiswa) async {
    final db = await database;
    return await db.insert('mahasiswa', mahasiswa.toMap());
  }

  Future<List<Mahasiswa>> getMahasiswa() async {
    final db = await database;
    final maps = await db.query('mahasiswa', orderBy: 'id DESC');
    return maps.map((map) => Mahasiswa.fromMap(map)).toList();
  }

  Future<int> updateMahasiswa(Mahasiswa mahasiswa) async {
    final db = await database;
    return await db.update(
      'mahasiswa',
      mahasiswa.toMap(),
      where: 'id = ?',
      whereArgs: [mahasiswa.id],
    );
  }

  Future<int> deleteMahasiswa(int id) async {
    final db = await database;
    return await db.delete(
      'mahasiswa',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
