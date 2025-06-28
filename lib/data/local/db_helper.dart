import 'package:nikita_flutter_interview/data/models/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database? _db;

  static const String _table = 'tasks';

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'tasks.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_table (
            id TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            dueDate TEXT,
            priority INTEGER,
            updatedAt TEXT,
            isDirty INTEGER,
            isSynced INTEGER
          )
        ''');
      },
    );
  }

  static Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert(
      _table,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Task>> getTasks() async {
    final db = await database;
    final maps = await db.query(_table);
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  static Future<void> deleteTask(String id) async {
    final db = await database;
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<Task?> getTask(String id) async {
    final db = await database;
    final maps = await db.query(_table, where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Task.fromMap(maps.first);
    } else {
      return null;
    }
  }
}
