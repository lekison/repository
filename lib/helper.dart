import 'package:package_1/history.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'payment_history.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE payment_history(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            customerName TEXT,
            packageName TEXT,
            amount REAL,
            date TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertPayment(PaymentHistory payment) async {
    final db = await database;
    await db.insert(
      'payment_history',
      payment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PaymentHistory>> getPayments() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('payment_history');

    return List.generate(maps.length, (i) {
      return PaymentHistory.fromMap(maps[i]);
    });
  }

  Future<void> updatePayment(PaymentHistory payment) async {
    final db = await database;
    await db.update(
      'payment_history',
      payment.toMap(),
      where: 'id = ?',
      whereArgs: [payment.id],
    );
  }

  Future<void> deletePayment(int id) async {
    final db = await database;
    await db.delete(
      'payment_history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
