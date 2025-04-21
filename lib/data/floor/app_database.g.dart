// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CategoryDao? _categoryDaoInstance;

  FinancialEntryDao? _financialEntryDaoInstance;

  GoalDao? _goalDaoInstance;

  UserDao? _userDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `category` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `FinancialEntryEntity` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `value` REAL NOT NULL, `category_id` TEXT NOT NULL, `type` TEXT NOT NULL, `date` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `goals` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `description` TEXT, `targetValue` REAL NOT NULL, `currentValue` REAL NOT NULL, `deadline` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `users` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `email` TEXT NOT NULL, `password` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await database.execute(
            'CREATE VIEW IF NOT EXISTS `MonthlyTotalView` AS   SELECT \n    strftime(\'%Y-%m\', date) AS month, \n    type, \n    SUM(value) AS total \n  FROM financialentryentity \n  GROUP BY month, type\n');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CategoryDao get categoryDao {
    return _categoryDaoInstance ??= _$CategoryDao(database, changeListener);
  }

  @override
  FinancialEntryDao get financialEntryDao {
    return _financialEntryDaoInstance ??=
        _$FinancialEntryDao(database, changeListener);
  }

  @override
  GoalDao get goalDao {
    return _goalDaoInstance ??= _$GoalDao(database, changeListener);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }
}

class _$CategoryDao extends CategoryDao {
  _$CategoryDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _categoryEntityInsertionAdapter = InsertionAdapter(
            database,
            'category',
            (CategoryEntity item) =>
                <String, Object?>{'id': item.id, 'name': item.name});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CategoryEntity> _categoryEntityInsertionAdapter;

  @override
  Future<List<CategoryEntity>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM category',
        mapper: (Map<String, Object?> row) => CategoryEntity(
            id: row['id'] as String, name: row['name'] as String));
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM category WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> insertCategory(CategoryEntity category) async {
    await _categoryEntityInsertionAdapter.insert(
        category, OnConflictStrategy.replace);
  }
}

class _$FinancialEntryDao extends FinancialEntryDao {
  _$FinancialEntryDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _financialEntryEntityInsertionAdapter = InsertionAdapter(
            database,
            'FinancialEntryEntity',
            (FinancialEntryEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'value': item.value,
                  'category_id': item.categoryId,
                  'type': _financialEntryTypeConverter.encode(item.type),
                  'date': item.date
                }),
        _financialEntryEntityDeletionAdapter = DeletionAdapter(
            database,
            'FinancialEntryEntity',
            ['id'],
            (FinancialEntryEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'value': item.value,
                  'category_id': item.categoryId,
                  'type': _financialEntryTypeConverter.encode(item.type),
                  'date': item.date
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FinancialEntryEntity>
      _financialEntryEntityInsertionAdapter;

  final DeletionAdapter<FinancialEntryEntity>
      _financialEntryEntityDeletionAdapter;

  @override
  Future<List<FinancialEntryEntity>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM financialentryentity',
        mapper: (Map<String, Object?> row) => FinancialEntryEntity(
            id: row['id'] as String,
            name: row['name'] as String,
            value: row['value'] as double,
            categoryId: row['category_id'] as String,
            type: _financialEntryTypeConverter.decode(row['type'] as String),
            date: row['date'] as String));
  }

  @override
  Future<List<MonthlyTotalView>> getMonthlyTotals() async {
    return _queryAdapter.queryList('SELECT * FROM MonthlyTotalView',
        mapper: (Map<String, Object?> row) => MonthlyTotalView(
            row['month'] as String,
            row['type'] as String,
            row['total'] as double));
  }

  @override
  Future<void> insertEntry(FinancialEntryEntity entry) async {
    await _financialEntryEntityInsertionAdapter.insert(
        entry, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteEntry(FinancialEntryEntity entry) async {
    await _financialEntryEntityDeletionAdapter.delete(entry);
  }
}

class _$GoalDao extends GoalDao {
  _$GoalDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _goalEntityInsertionAdapter = InsertionAdapter(
            database,
            'goals',
            (GoalEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'targetValue': item.targetValue,
                  'currentValue': item.currentValue,
                  'deadline': item.deadline
                }),
        _goalEntityUpdateAdapter = UpdateAdapter(
            database,
            'goals',
            ['id'],
            (GoalEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'targetValue': item.targetValue,
                  'currentValue': item.currentValue,
                  'deadline': item.deadline
                }),
        _goalEntityDeletionAdapter = DeletionAdapter(
            database,
            'goals',
            ['id'],
            (GoalEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'targetValue': item.targetValue,
                  'currentValue': item.currentValue,
                  'deadline': item.deadline
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<GoalEntity> _goalEntityInsertionAdapter;

  final UpdateAdapter<GoalEntity> _goalEntityUpdateAdapter;

  final DeletionAdapter<GoalEntity> _goalEntityDeletionAdapter;

  @override
  Future<List<GoalEntity>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM goals',
        mapper: (Map<String, Object?> row) => GoalEntity(
            id: row['id'] as String,
            name: row['name'] as String,
            description: row['description'] as String?,
            targetValue: row['targetValue'] as double,
            currentValue: row['currentValue'] as double,
            deadline: row['deadline'] as String));
  }

  @override
  Future<GoalEntity?> findByName(String name) async {
    return _queryAdapter.query('SELECT * FROM goals WHERE name = ?1',
        mapper: (Map<String, Object?> row) => GoalEntity(
            id: row['id'] as String,
            name: row['name'] as String,
            description: row['description'] as String?,
            targetValue: row['targetValue'] as double,
            currentValue: row['currentValue'] as double,
            deadline: row['deadline'] as String),
        arguments: [name]);
  }

  @override
  Future<void> updateCurrentValue(
    String id,
    double currentValue,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE goals SET currentValue = ?2 WHERE id = ?1',
        arguments: [id, currentValue]);
  }

  @override
  Future<int> insertGoal(GoalEntity goal) {
    return _goalEntityInsertionAdapter.insertAndReturnId(
        goal, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateGoal(GoalEntity goal) {
    return _goalEntityUpdateAdapter.updateAndReturnChangedRows(
        goal, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteGoal(GoalEntity goal) async {
    await _goalEntityDeletionAdapter.delete(goal);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userEntityInsertionAdapter = InsertionAdapter(
            database,
            'users',
            (UserEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'password': item.password
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserEntity> _userEntityInsertionAdapter;

  @override
  Future<UserEntity?> findUserByEmailAndPassword(
    String email,
    String password,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM users WHERE email = ?1 AND password = ?2',
        mapper: (Map<String, Object?> row) => UserEntity(
            id: row['id'] as String,
            name: row['name'] as String,
            email: row['email'] as String,
            password: row['password'] as String),
        arguments: [email, password]);
  }

  @override
  Future<UserEntity?> findUserByEmail(String email) async {
    return _queryAdapter.query('SELECT * FROM users WHERE email = ?1',
        mapper: (Map<String, Object?> row) => UserEntity(
            id: row['id'] as String,
            name: row['name'] as String,
            email: row['email'] as String,
            password: row['password'] as String),
        arguments: [email]);
  }

  @override
  Future<void> deleteUser(String id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM users WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> insertUser(UserEntity user) async {
    await _userEntityInsertionAdapter.insert(user, OnConflictStrategy.replace);
  }
}

// ignore_for_file: unused_element
final _financialEntryTypeConverter = FinancialEntryTypeConverter();
