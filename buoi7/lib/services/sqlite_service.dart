import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/favorite_route.dart';

class SqliteService {
  static final SqliteService instance = SqliteService._init();
  static Database? _database;

  SqliteService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('favorite_routes.db');
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
      CREATE TABLE favorite_routes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        startAddress TEXT NOT NULL,
        startLat REAL NOT NULL,
        startLng REAL NOT NULL,
        endAddress TEXT NOT NULL,
        endLat REAL NOT NULL,
        endLng REAL NOT NULL,
        travelMode TEXT NOT NULL,
        distanceText TEXT NOT NULL,
        durationText TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertFavoriteRoute(FavoriteRoute route) async {
    final db = await instance.database;
    return await db.insert('favorite_routes', route.toMap());
  }

  Future<List<FavoriteRoute>> getAllFavoriteRoutes() async {
    final db = await instance.database;
    final result = await db.query('favorite_routes', orderBy: 'id DESC');
    return result.map((json) => FavoriteRoute.fromMap(json)).toList();
  }

  Future<int> deleteFavoriteRoute(int id) async {
    final db = await instance.database;
    return await db.delete(
      'favorite_routes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
