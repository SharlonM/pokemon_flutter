import 'package:floor/floor.dart';

@Entity(tableName: 'Pokes')
class PokeEntidade {
  PokeEntidade(this.id, this.updateAt, this.name, this.urlFoto, this.type,
      this.abilitie1, this.abilitie2, this.abilitie3, this.favorite);

  @primaryKey
  final int id;
  final String updateAt;
  final String name;
  final String urlFoto;
  final String type;
  final String abilitie1;
  final String abilitie2;
  final String abilitie3;
  final int favorite;
}
