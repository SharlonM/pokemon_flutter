import 'package:floor/floor.dart';
import 'package:movies_flutter/DB/Entidades/poke_entidade.dart';

@dao
abstract class PokesDao {
  @Query('SELECT * FROM Pokes')
  Future<List<PokeEntidade>> getAllPokes();

  @Query(
      'CREATE TABLE IF NOT EXISTS `Pokes` (`id` INTEGER NOT NULL, `updateAt` TEXT NOT NULL, `name` TEXT NOT NULL, `urlFoto` TEXT NOT NULL, `type` TEXT NOT NULL, `abilitie1` TEXT NOT NULL, `abilitie2` TEXT NOT NULL, `abilitie3` TEXT NOT NULL, PRIMARY KEY (`id`))')
  Future<int?> createDatabase();

  @Query('SELECT * FROM Pokes WHERE name = :name')
  Future<List<PokeEntidade>> getPokeByName(String name);

  @Query('SELECT * FROM Pokes WHERE favorite = 1')
  Future<List<PokeEntidade>> getPokeFav();

  @Query('DROP TABLE Pokes')
  Future<int?> dropTable();

  @insert
  Future<int> insertPoke(PokeEntidade poke);

  @Query('DELETE FROM Pokes WHERE id != 0')
  Future<int?> deletePokes();

  @Query('')
  Future<int?> setPokeFav(int id);

  @Query('')
  Future<int?> setPokeNoFav(int id);

  @insert
  Future<List<int>> insertListPokes(List<PokeEntidade> pokes);
}
