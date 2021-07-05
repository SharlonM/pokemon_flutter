import 'package:flutter/material.dart';
import 'package:movies_flutter/DB/Entidades/poke_entidade.dart';
import 'package:movies_flutter/DB/database.dart';
import 'package:movies_flutter/Widgets/view_details.dart';
import 'package:movies_flutter/utils.dart';

class ViewFavPokes extends StatefulWidget {
  const ViewFavPokes({Key? key, required this.db}) : super(key: key);

  final AppDatabase db;

  @override
  _ViewFavPokesState createState() => _ViewFavPokesState();
}

class _ViewFavPokesState extends State<ViewFavPokes> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Utils.logo(),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(5),
            child: FutureBuilder<List<PokeEntidade>>(
                future: widget.db.pokesDao.getPokeFav(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      (snapshot.hasData && snapshot.data!.isEmpty)) {
                    // não tem dados
                    return _textCaseNoFavorites();
                  } else {
                    return GridView.builder(
                      // tem dados
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, int index) {
                        PokeEntidade poke = snapshot.data![index];
                        return Card(
                          child: Center(child: _miniatura(poke)),
                        );
                      },
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget _miniatura(PokeEntidade poke) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                _onClick(poke);
              },
              child: Image.network(
                poke.urlFoto,
                height: 150,
                errorBuilder: (context, ex, stac) {
                  return const Icon(
                    Icons.wifi_off,
                    size: 100,
                  );
                },
              ),
            ),
          ),
          Text(
            poke.name[0].toUpperCase() + poke.name.substring(1),
            style: Utils.getStyle(18, fs: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  _onClick(PokeEntidade poke) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ViewDetails(poke, widget.db)));
    setState(() {});
  }

  Widget _textCaseNoFavorites() {
    return Padding(
      padding: const EdgeInsets.only(left: 100, top: 20),
      child: Text(
        'Adicione favoritos',
        style: Utils.getStyle(28),
      ),
    );
  }
}
