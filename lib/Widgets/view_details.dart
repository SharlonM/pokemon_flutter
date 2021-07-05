import 'package:flutter/material.dart';
import 'package:movies_flutter/DB/Entidades/poke_entidade.dart';
import 'package:movies_flutter/DB/database.dart';
import 'package:movies_flutter/utils.dart';

class ViewDetails extends StatefulWidget {
  const ViewDetails(this._poke, this.db, {Key? key}) : super(key: key);
  final PokeEntidade _poke;
  final AppDatabase db;

  @override
  State<ViewDetails> createState() => _ViewDetailsState();
}

bool _favorito = false;

class _ViewDetailsState extends State<ViewDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.appBar('Detalhes'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _pokeLogo(),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_titulos(), const SizedBox(width: 30), _respostas()],
          ),
          const SizedBox(height: 20),
          _btnFavorito(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _favorito = widget._poke.favorite == 1 ? true : false;
  }

  void _favoritar(int id) async {
    if (_favorito) {
      await widget.db.pokesDao.setPokeNoFav(id);
    } else {
      await widget.db.pokesDao.setPokeFav(id);
    }
    setState(() {
      _favorito = !_favorito;
    });
  }

  Widget _box() {
    return const SizedBox(height: 10);
  }

  Widget _pokeLogo() {
    return Image.network(
      widget._poke.urlFoto,
      height: 200,
      errorBuilder: (context, ex, stack) {
        return Column(
          children: [
            const Icon(
              Icons.wifi_off,
              size: 200,
            ),
            Text(
              'Sem conexão, não foi possivel baixar a imagem',
              style: Utils.getStyle(16, cor: Colors.red),
            )
          ],
        );
      },
    );
  }

  _titulos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nome:', style: Utils.getStyle(22, cor: Colors.amber)),
        _box(),
        Text('Id:', style: Utils.getStyle(22, cor: Colors.amber)),
        _box(),
        Text('Tipo:', style: Utils.getStyle(22, cor: Colors.amber)),
        _box(),
        Text('Habilidade 1:', style: Utils.getStyle(22, cor: Colors.amber)),
        _box(),
        Text('Habilidade 2:', style: Utils.getStyle(22, cor: Colors.amber)),
        _box(),
        Text('Atualizado:', style: Utils.getStyle(22, cor: Colors.amber)),
        _box(),
        Text('Favorito:', style: Utils.getStyle(22, cor: Colors.amber)),
      ],
    );
  }

  _respostas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget._poke.name.toUpperCase(), style: Utils.getStyle(22)),
        _box(),
        Text(widget._poke.id.toString().toUpperCase(),
            style: Utils.getStyle(22)),
        _box(),
        Text(widget._poke.type.toUpperCase(), style: Utils.getStyle(22)),
        _box(),
        Text(widget._poke.abilitie1.toUpperCase(), style: Utils.getStyle(22)),
        _box(),
        Text(widget._poke.abilitie2.toUpperCase(), style: Utils.getStyle(22)),
        _box(),
        Text(widget._poke.updateAt.toUpperCase().substring(0, 10).toUpperCase(),
            style: Utils.getStyle(22)),
        _box(),
        Text(_favorito ? 'SIM' : 'NÃO', style: Utils.getStyle(22)),
      ],
    );
  }

  _btnFavorito() {
    return IconButton(
      tooltip: 'Adicionar pokemon aos favoritos',
      onPressed: () {
        _favoritar(widget._poke.id);
      },
      icon: _favorito
          ? const Icon(
              Icons.favorite,
              size: 40,
              color: Colors.red,
            )
          : const Icon(
              Icons.favorite_border_outlined,
              size: 40,
            ),
    );
  }
}
