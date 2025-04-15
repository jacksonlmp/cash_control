// lib/data/database_helper.dart
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

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
    String path = join(await getDatabasesPath(), 'cashcontrol.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE category (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE financial_entry (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        value REAL NOT NULL,
        category_id TEXT NOT NULL,
        type TEXT CHECK(type IN ('DESPESA', 'RECEITA')) NOT NULL,
        date TEXT NOT NULL,
        FOREIGN KEY (category_id) REFERENCES category(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE goals (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      description TEXT,
      targetValue REAL NOT NULL,
      currentValue REAL NOT NULL,
      deadline TEXT NOT NULL
    )
    ''');

    // Adicionar demais tabelas
  }

  // Função de depuração para imprimir os dados do banco de dados
  Future<void> printUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> users = await db.query('users');
    for (var user in users) {
      print(user);
    }
  }

  // Função de depuração para imprimir os dados do banco de dados
  Future<List<Map<String, dynamic>>> printCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> categories = await db.query('category');
    for (var category in categories) {
      print(category);
    }
    return categories;
  }

  Future<void> printFinancialEntries() async {
    final db = await database;
    final List<Map<String, dynamic>> financialEntries = await db.query('financial_entry');

    for (var entry in financialEntries) {
      print(entry);
    }
  }

  Future<void> printGoal() async {
    final db = await database;
    final List<Map<String, dynamic>> goals = await db.query('goals');
    for (var goal in goals) {
      print(goal);
    }
  }

  // Função para exportar o banco de dados
  Future<void> exportDatabase() async {
    try {
      // Obter o caminho do banco de dados atual
      final dbPath = await getDatabasesPath();
      final dbFilePath = join(dbPath, 'cashcontrol.db');

      // Verificar se o banco de dados existe
      final dbFile = File(dbFilePath);
      if (!dbFile.existsSync()) {
        print('Banco de dados não encontrado.');
        return;
      }

      // Obter o diretório de destino (pasta de downloads)
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        print('Não foi possível acessar o diretório externo.');
        return;
      }
      final exportFilePath = join(directory.path, 'cashcontrol_export.db');

      // Copiar o banco de dados para o diretório de destino
      final exportFile = File(exportFilePath);
      await dbFile.copy(exportFile.path);

      print('Banco de dados exportado para: $exportFilePath');
    } catch (e) {
      print('Erro ao exportar o banco de dados: $e');
    }
  }

  // função para deletar o banco (chamar no main se necessário)
  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'cashcontrol.db');
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
      print('Banco deletado com sucesso');
    }
  }
}
