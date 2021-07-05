import 'package:flutter/material.dart';
import 'package:movies_flutter/API/modal_api.dart';
import 'package:movies_flutter/DB/Entidades/poke_entidade.dart';
import 'package:movies_flutter/DB/database.dart';
import 'package:movies_flutter/Widgets/view_details.dart';
import 'package:movies_flutter/utils.dart';

class ViewAllPokes extends StatefulWidget {
  const ViewAllPokes({Key? key, required this.db}) : super(key: key);

  final AppDatabase db;

  @override
  _ViewAllPokesState createState() => _ViewAllPokesState();
}

class _ViewAllPokesState extends State<ViewAllPokes> {
  List<PokeEntidade> listPoke = [];
  final List<Widget> _more = [
    const Icon(Icons.add_circle_outline, size: 60),
    const CircularProgressIndicator()
  ];
  int _moreIndex = 0;

  Future<List<PokeEntidade>> _loadList(bool local) async {
    List<PokeEntidade> listAux = [];
    if (local) {
      listAux = await widget.db.pokesDao.getAllPokes();
      if (listAux.isEmpty) {
        // chamar via api
        listAux = await Api.getPokes(listPoke.length);
      }
    } else {
      listAux = await Api.getPokes(listPoke.length);
    }
    setState(() {
      if (local) {
        listPoke = listAux;
      } else {
        listPoke += listAux;
      }
      _moreIndex = 0;
    });
    await widget.db.pokesDao.insertListPokes(listPoke);
    return listPoke;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.db.pokesDao.createDatabase();
    _loadList(true);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Utils.logo(),
          Container(
            height: MediaQuery.of(context).size.height - 250,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 5, crossAxisCount: 2, crossAxisSpacing: 5),
              itemCount: listPoke.length + 1,
              itemBuilder: (context, int index) {
                if (listPoke.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (index == listPoke.length) {
                  return Padding(
                      padding: const EdgeInsets.all(10), child: _imgCarregar());
                }
                PokeEntidade poke = listPoke[index];
                return Card(
                  child: Center(child: _miniatura(poke)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _imgCarregar() {
    return InkWell(
      onTap: () {
        setState(() {
          _moreIndex = 1;
          _carregarMais();
        });
      },
      child: Center(
        child: _more[_moreIndex],
      ),
    );
  }

  void _carregarMais() async {
    await _loadList(false);
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
          )),
          Text(
            poke.name[0].toUpperCase() + poke.name.substring(1),
            style: Utils.getStyle(18, fs: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  _onClick(PokeEntidade poke) async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    var x = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewDetails(poke, widget.db)))
        .then((value) => {_loadList(true)});
    Navigator.pop(context);
  }
}
