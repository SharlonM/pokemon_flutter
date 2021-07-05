import 'package:flutter/material.dart';
import 'package:movies_flutter/API/modal_api.dart';
import 'package:movies_flutter/DB/Entidades/poke_entidade.dart';
import 'package:movies_flutter/DB/database.dart';
import 'package:movies_flutter/Widgets/view_details.dart';
import 'package:movies_flutter/utils.dart';

class ViewSearchPokes extends StatefulWidget {
  const ViewSearchPokes({Key? key, required this.db}) : super(key: key);

  final AppDatabase db;

  @override
  _ViewSearchPokesState createState() => _ViewSearchPokesState();
}

TextEditingController _controller = TextEditingController();
String _input = "";
List<PokeEntidade> _listPoke = [];

class _ViewSearchPokesState extends State<ViewSearchPokes> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          _campoDeTexto(),
          _btnPesquisar(),
          Container(
            height: MediaQuery.of(context).size.height - 300,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(5),
            child: FutureBuilder<List<PokeEntidade>>(
                // primeiro consulta local
                future: _input.isNotEmpty
                    ? widget.db.pokesDao.getPokeByName(_input.toLowerCase())
                    : null,
                builder: (context, snapshot) {
                  if (snapshot.connectionState.index == 1) {
                    return _aguardar();
                  } else if (snapshot.hasData &&
                      snapshot.data!.isEmpty &&
                      snapshot.connectionState.index == 3) {
                    return _consultaViaApi();
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    _listPoke = snapshot.data!;
                    return _showResultLocal();
                  } else {
                    return const Text('');
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget _aguardar() {
    Widget retorno = const Center(child: Text('nada encontrado'));
    for (int i = 0; i < 1000; i++) {
      if (i < 90) {
        retorno = const Center(child: CircularProgressIndicator());
      } else {
        retorno = const Center(child: Text('nada encontrado'));
      }
      return retorno;
    }
    return retorno;
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

  _campoDeTexto() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: TextField(
        controller: _controller,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Digite o nome do pokemon'),
      ),
    );
  }

  _btnPesquisar() {
    return Container(
      padding: const EdgeInsets.all(1),
      height: 50,
      width: 150,
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            _input = _controller.text.trim();
          });
        },
        child: const Text('Pesquisar'),
        style: OutlinedButton.styleFrom(
            backgroundColor: Colors.amber, textStyle: Utils.getStyle(15)),
      ),
    );
  }

  Widget _consultaViaApi() {
    return FutureBuilder<PokeEntidade?>(
        future: Api.getPokeByName(_input.toLowerCase()),
        builder: (context, snapshot) {
          if (snapshot.connectionState.index == 1) {
            return _aguardar();
          } else if (snapshot.data == null &&
              snapshot.connectionState.index == 3) {
            return const Text('Nada encontrado na busca');
          } else if (snapshot.hasData) {
            widget.db.pokesDao.insertPoke(snapshot.data!);
            return Card(
              child: Center(child: _miniatura(snapshot.data!)),
            );
          } else {
            return const Text('desconhecido');
          }
        });
  }

  Widget _showResultLocal() {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: _listPoke.length,
      itemBuilder: (context, int index) {
        return Card(
          child: Center(child: _miniatura(_listPoke[index])),
        );
      },
    );
  }
}
