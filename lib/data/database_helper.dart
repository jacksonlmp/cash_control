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
}
