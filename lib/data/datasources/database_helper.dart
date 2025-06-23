import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("barang.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''CREATE TABLE kategori (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nama_kategori TEXT NOT NULL
    )''');

    await db.execute('''CREATE TABLE barang (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nama_barang TEXT NOT NULL,
      kategori_id INTEGER NOT NULL,
      stok INTEGER NOT NULL,
      kelompok_barang TEXT NOT NULL,
      harga INTEGER NOT NULL,
      FOREIGN KEY (kategori_id) REFERENCES kategori (id)
    )''');

    await db.insert('kategori', {'nama_kategori': 'Elektronik'});
    await db.insert('kategori', {'nama_kategori': 'Pakaian'});
  }
}
