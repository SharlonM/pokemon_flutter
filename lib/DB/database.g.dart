part of 'database.dart';

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
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

  PokesDao? _pokesDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
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
            'CREATE TABLE IF NOT EXISTS `Pokes` (`id` INTEGER NOT NULL, `updateAt` TEXT NOT NULL, `name` TEXT NOT NULL, `urlFoto` TEXT NOT NULL, `type` TEXT NOT NULL, `abilitie1` TEXT NOT NULL, `abilitie2` TEXT NOT NULL, `abilitie3` TEXT NOT NULL, `favorite` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PokesDao get pokesDao {
    return _pokesDaoInstance ??= _$PokesDao(database, changeListener);
  }
}

class _$PokesDao extends PokesDao {
  _$PokesDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _pokeEntidadeInsertionAdapter = InsertionAdapter(
            database,
            'Pokes',
            (PokeEntidade item) => <String, Object?>{
                  'id': item.id,
                  'updateAt': item.updateAt,
                  'name': item.name,
                  'urlFoto': item.urlFoto,
                  'type': item.type,
                  'abilitie1': item.abilitie1,
                  'abilitie2': item.abilitie2,
                  'abilitie3': item.abilitie3,
                  'favorite': item.favorite
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PokeEntidade> _pokeEntidadeInsertionAdapter;

  @override
  Future<List<PokeEntidade>> getAllPokes() async {
    return _queryAdapter.queryList('SELECT * FROM Pokes',
        mapper: (Map<String, Object?> row) => PokeEntidade(
            row['id'] as int,
            row['updateAt'] as String,
            row['name'] as String,
            row['urlFoto'] as String,
            row['type'] as String,
            row['abilitie1'] as String,
            row['abilitie2'] as String,
            row['abilitie3'] as String,
            row['favorite'] as int));
  }

  @override
  Future<List<PokeEntidade>> getPokeByName(String name) async {
    return _queryAdapter.queryList(
        "SELECT * FROM Pokes WHERE name LIKE '$name%'",
        mapper: (Map<String, Object?> row) => PokeEntidade(
            row['id'] as int,
            row['updateAt'] as String,
            row['name'] as String,
            row['urlFoto'] as String,
            row['type'] as String,
            row['abilitie1'] as String,
            row['abilitie2'] as String,
            row['abilitie3'] as String,
            row['favorite'] as int));
  }

  @override
  Future<int?> dropTable() async {
    await _queryAdapter.queryNoReturn('DROP TABLE Pokes');
  }

  @override
  Future<int?> deletePokes() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Pokes WHERE id != 0');
  }

  @override
  Future<int> insertPoke(PokeEntidade poke) {
    return _pokeEntidadeInsertionAdapter.insertAndReturnId(
        poke, OnConflictStrategy.replace);
  }

  @override
  Future<int?> createDatabase() async {
    await _queryAdapter.queryNoReturn(
        'CREATE TABLE IF NOT EXISTS `Pokes` (`id` INTEGER NOT NULL, `updateAt` TEXT NOT NULL, `name` TEXT NOT NULL, `urlFoto` TEXT NOT NULL, `type` TEXT NOT NULL, `abilitie1` TEXT NOT NULL, `abilitie2` TEXT NOT NULL, `abilitie3` TEXT NOT NULL, `favorite` INTEGER NOT NULL, PRIMARY KEY (`id`))');
  }

  @override
  Future<List<int>> insertListPokes(List<PokeEntidade> pokes) {
    return _pokeEntidadeInsertionAdapter.insertListAndReturnIds(
        pokes, OnConflictStrategy.replace);
  }

  @override
  Future<int?> setPokeFav(int id) async {
    String data = DateTime.now().toString();
    await _queryAdapter.queryNoReturn(
        "UPDATE Pokes SET favorite = 1, updateAt = '$data' WHERE id == $id");
  }

  @override
  Future<int?> setPokeNoFav(int id) async {
    String data = DateTime.now().toString();
    await _queryAdapter.queryNoReturn(
        "UPDATE Pokes SET favorite = 0, updateAt = '$data' WHERE id == $id");
  }

  @override
  Future<List<PokeEntidade>> getPokeFav() {
    return _queryAdapter.queryList(
      'SELECT * FROM Pokes WHERE favorite = 1',
      mapper: (Map<String, Object?> row) => PokeEntidade(
          row['id'] as int,
          row['updateAt'] as String,
          row['name'] as String,
          row['urlFoto'] as String,
          row['type'] as String,
          row['abilitie1'] as String,
          row['abilitie2'] as String,
          row['abilitie3'] as String,
          row['favorite'] as int),
    );
  }
}
