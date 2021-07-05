import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies_flutter/DB/Entidades/poke_entidade.dart';

class Api {
  static Future<List<PokeEntidade>> getPokes(int offset) async {
    List<PokeEntidade> listPokes = [];
    var response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon?offset=$offset&limit=10'));
    Map json = jsonDecode(response.body);
    List<dynamic> results = json['results'];
    for (var element in results) {
      String url = element['url'];
      response = await http.get(Uri.parse(url));
      json = jsonDecode(response.body);
      listPokes.add(_conversao(json));
    }
    return listPokes;
  }

  static Future<PokeEntidade?> getPokeByName(String name) async {
    try {
      var response =
          await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$name'));
      Map json = jsonDecode(response.body);
      return _conversao(json);
    } catch (e) {
      return null;
    }
  }

  static PokeEntidade _conversao(json) {
    int id = json['id'];
    String name = json['name'];
    String imageurl =
        json['sprites']['other']['official-artwork']['front_default'];
    String tipo = json['types'][0]['type']['name'];
    List<dynamic> habilidades = json['abilities'];
    List<String> abilities = [];
    for (var ability in habilidades) {
      abilities.add(ability['ability']['name']);
    }
    for (int i = 0; i < 3; i++) {
      abilities.add("");
    }
    PokeEntidade poke = PokeEntidade(id, DateTime.now().toString(), name,
        imageurl, tipo, abilities[0], abilities[1], abilities[2], 0);
    return poke;
  }
}
