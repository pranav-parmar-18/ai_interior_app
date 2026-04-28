import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/music_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('music_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE music (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        lyrics TEXT,
        filePath TEXT,
        imagePath TEXT,
        isFavorite INTEGER DEFAULT 0
      )
    ''');
  }

  // Insert Music
  Future<int> insertMusic(Music music) async {
    final db = await instance.database;
    return await db.insert('music', music.toMap());
  }

  Future<int> updateMusicName(int id, String newName) async {
    final db = await database;

    return await db.update(
      'music',
      {'name': newName}, // Only updating the name field
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get All Music
  Future<List<Music>> getAllMusic() async {
    final db = await instance.database;
    final result = await db.query('music');

    return result.map((map) => Music.fromMap(map)).toList();
  }

  Future<List<Music>> getFavoriteMusic() async {
    final db = await instance.database;
    final result = await db.query(
      'music',
      where: 'isFavorite = ?',
      whereArgs: [1], // Fetch only favorite songs
    );

    return result.map((map) => Music.fromMap(map)).toList();
  }

  // Get Single Music
  Future<Music?> getMusicById(int id) async {
    final db = await instance.database;
    final result = await db.query('music', where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return Music.fromMap(result.first);
    } else {
      return null;
    }
  }

  // Update Music
  Future<int> updateMusic(Music music) async {
    final db = await instance.database;
    return await db.update(
      'music',
      music.toMap(),
      where: 'id = ?',
      whereArgs: [music.id],
    );
  }

  Future<void> updateFavoriteStatus(int id, int isFavorite) async {
    final db = await DatabaseHelper.instance.database;

    await db.update(
      'music',
      {'isFavorite': isFavorite}, // Update the column
      where: 'id = ?',
      whereArgs: [id],
    );

    print('Updated isFavorite for ID: $id to $isFavorite');
  }

  Future<bool> isFavorite(int id) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      'music',
      columns: ['isFavorite'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return result.first['isFavorite'] == 1; // Returns true if 1, else false
    }

    return false; // Default to false if song is not found
  }



  // Delete Music
  Future<void> deleteMusic(int id) async {
    final db = await instance.database;

    final result = await db.query('music', where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      await db.delete('music', where: 'id = ?', whereArgs: [id]);
      print("Music deleted successfully!");
    } else {
      print("Music with ID $id not found!");
    }
  }

  Future<void> addIsFavoriteColumn() async {
    final db = await DatabaseHelper.instance.database;

    // Check if column already exists
    final tableInfo = await db.rawQuery("PRAGMA table_info(music)");
    final columnExists = tableInfo.any((column) => column['name'] == 'isFavorite');

    if (!columnExists) {
      await db.execute('ALTER TABLE music ADD COLUMN isFavorite INTEGER DEFAULT 0;');
      print('Column isFavorite added successfully!');
    } else {
      print('Column isFavorite already exists.');
    }
  }

}
