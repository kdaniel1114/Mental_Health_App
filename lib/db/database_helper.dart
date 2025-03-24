import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  static const String _databaseName = "mood_tracker.db";
  static const int _databaseVersion = 1;

  static const String tableMood = "mood_history";

  static const String columnId = "id";
  static const String timestamp = "timestamp";
  static const String columnMood = "mood";
  static const String columnNote = "note";

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableMood (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $timestamp TEXT NOT NULL,
        $columnMood TEXT NOT NULL,
        $columnNote TEXT
      )
    ''');
  }

  /// ✅ Corrected `insertMood` method
  Future<int> insertMood(String mood, String note) async {
    Database db = await database;
    String now = DateTime.now().toIso8601String(); // Full timestamp (YYYY-MM-DD HH:MM:SS)

    return await db.insert(tableMood, {
      timestamp: now, // ✅ Uses the correct constant
      columnMood: mood,
      columnNote: note,
    });
  }

  /// ✅ Fixed `getAllMoods` (now orders by `timestamp`, not `date`)
  Future<List<Map<String, dynamic>>> getAllMoods() async {
    final db = await database;
    return await db.query(tableMood, orderBy: '$timestamp DESC');
  }

  /// ✅ Delete all moods from the database
  Future<void> deleteAllMoods() async {
    final db = await database;
    await db.delete(tableMood);
  }

  /// ✅ Get moods for today only
  Future<List<Map<String, dynamic>>> getMoodsForToday() async {
    Database db = await database;
    String today = DateTime.now().toIso8601String().substring(0, 10); // YYYY-MM-DD
    
    return await db.query(
      tableMood, 
      where: "$timestamp LIKE ?", 
      whereArgs: ["$today%"], // Matches all moods from today
      orderBy: "$timestamp DESC" // Latest first
    );
  }

  /// ✅ Get moods for the last 7 days
  Future<List<Map<String, dynamic>>> getMoodsForThisWeek() async {
    Database db = await database;
    DateTime now = DateTime.now();
    DateTime weekAgo = now.subtract(Duration(days: 7));
    
    return await db.query(
      tableMood, 
      where: "$timestamp >= ?",
      whereArgs: [weekAgo.toIso8601String()],
      orderBy: "$timestamp ASC"
    );
  }
}