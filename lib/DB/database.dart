import 'dart:async';

import 'package:floor/floor.dart';
import 'package:movies_flutter/DB/Entidades/poke_entidade.dart';
import 'package:movies_flutter/DB/daos/pokes_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 1, entities: [PokeEntidade])
abstract class AppDatabase extends FloorDatabase {
  PokesDao get pokesDao;
}
