import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'systems_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE systems (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        system_id TEXT NOT NULL,
        name TEXT NOT NULL,
        address TEXT,
        azimuth REAL,
        angle REAL,
        latitude REAL,
        longitude REAL,
        capacity TEXT,
        panelno REAL,
        batteryno REAL
      )
    ''');
  }

  // Function to insert a new system into the table
  Future<int> insertSystem({
    required String systemId,
    required String name,
    required String address,
    required double azimuth,
    required double angle,
    required double latitude,
    required double longitude,
    required String capacity,
    required int panel_no,
    required int battery_no
  }) async {
    final db = await database;

    // Create the object (a Map) to be inserted
    final system = {
      'system_id': systemId,
      'name': name,
      'address': address,
      'azimuth': azimuth,
      'angle': angle,
      'latitude': latitude,
      'longitude': longitude,
      'capacity': capacity,
      'panelno' : panel_no,
      'batteryno' : battery_no
    };

    // Print the object to the console
    print('Inserting system: $system');

    // Insert the object into the database
    return await db.insert('systems', system);
  }


  // Function to retrieve all records
  Future<List<Map<String, dynamic>>> getAllSystems() async {
    final db = await database;
    return await db.query('systems');
  }

  // Function to retrieve records based on a specific system_id
  Future<List<Map<String, dynamic>>> getSystemsBySystemId(String systemId) async {
    final db = await database;
    return await db.query(
      'systems',
      where: 'system_id = ?',
      whereArgs: [systemId],
    );
  }

  // Function to check if a system exists
  Future<bool> isSystemExists(String systemId) async {
    final db = await database;
    final result = await db.query(
      'systems',
      where: 'system_id = ?',
      whereArgs: [systemId],
    );
    return result.isNotEmpty;
  }

  Future<int> deleteSystem(int id) async {
    final db = await database;
    return await db.delete(
      'systems',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, dynamic>?> getSystemById(int id) async {
    final db = await database;

    // Query the system based on the ID
    final result = await db.query(
      'systems',
      where: 'id = ?',
      whereArgs: [id],
    );

    // If the result is not empty, return the first matching row as a map
    if (result.isNotEmpty) {
      return result.first;
    }

    // If no system with the given id exists, return null
    return null;
  }

  // Function to update the angle of a system by id
  Future<int> updateSystemAngle(int id, double newAngle) async {
    final db = await database;
    print("Updated to ${newAngle}");
    return await db.update(
      'systems',
      {'angle': newAngle},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
