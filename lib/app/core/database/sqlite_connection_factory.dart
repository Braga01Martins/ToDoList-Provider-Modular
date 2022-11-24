import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:synchronized/synchronized.dart';
import 'sqlite_migration_factory.dart';

class SqliteConnectionFactory {
  static const _VERSION = 1;
  static const _DATABASE_NAME = 'TODO_LIST_PROVIDER';

  static SqliteConnectionFactory? _instance;

  Database? _db;
  final _lock = Lock(); // para trablahar em uma aplicação multitheades
  //lock é uma classe de dart:syncronized para trabalahr multithreads

  SqliteConnectionFactory._(); //contrutor privado da classe
 
 //factory cria uma instancia unica (padrão singleton)
 // na classe SqliteConnectionFactory
  factory SqliteConnectionFactory() {
    if (_instance == null) {
      _instance = SqliteConnectionFactory._();
    }
    return _instance!;
  }

  Future<Database> openConnection() async {
    var databasePath = await getDatabasesPath(); //para abrir conexão com banco de dados
    var databasePathFinal = join(databasePath, _DATABASE_NAME);
    if (_db == null) {
      await _lock.synchronized(() async {
        // ignore: prefer_conditional_assignment
        if (_db == null) {
          _db = await openDatabase(
            databasePathFinal,
            version: _VERSION,
            onConfigure: _onConfigure,
            onCreate: _onCreate,
            onUpgrade: _onUpgrade,
            onDowngrade: _onUDowngrade,
          );
        }
      });
    }

    return _db!; // retorna sabendo que nao é mais nulo !
  }

  void closeConnection() {
    _db?.close();
    _db = null;
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA FOREIGN_KEYS = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();
    final migrations = SqliteMigrationFactory().getCreateMigration();
    for (var migration in migrations) {
      migration.create(batch); // pega todas as migrations e executa cada uma delas.
    }
    batch.commit();
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int version) async {
    final batch = db.batch();
    final migrations = SqliteMigrationFactory().getUpgradeMigration(oldVersion);
    for (var migration in migrations) {
      migration.update(batch);
    }
    batch.commit();
  }

  Future<void> _onUDowngrade(Database db, int oldVersion, int version) async {}
}
