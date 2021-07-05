import 'package:flutter/material.dart';
import 'package:movies_flutter/DB/Entidades/poke_entidade.dart';
import 'package:movies_flutter/DB/database.dart';
import 'package:movies_flutter/Widgets/view_all_pokes.dart';
import 'package:movies_flutter/Widgets/view_fav_pokes.dart';
import 'package:movies_flutter/Widgets/view_search_pokes.dart';
import 'package:movies_flutter/utils.dart';
import 'package:window_size/window_size.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setWindowTitle('Poke App');
  setWindowFrame(const Rect.fromLTRB(0, 0, 526, 871));
  setWindowMaxSize(const Size(550, 900));
  setWindowMinSize(const Size(510, 810));
  runApp(MyApp(
    db: await $FloorAppDatabase.databaseBuilder('app_database.db').build(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.db}) : super(key: key);
  final AppDatabase db;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Poke Info', db: db),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.db})
      : super(key: key);

  final String title;
  final AppDatabase db;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // variaveis
  List<PokeEntidade> pokes = [];
  int _selectedTab = 0;
  String _title = "Todos os Pokemons";
  static List<Widget>? _widgets;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _widgets = <Widget>[
      ViewAllPokes(db: widget.db),
      ViewSearchPokes(db: widget.db),
      ViewFavPokes(db: widget.db)
    ];
  }

  void _onTabSelected(int index) {
    setState(() {
      switch (index) {
        case 0:
          _title = "Todos os Pokemons";
          break;
        case 1:
          _title = "Pesquise seu Pokemon";
          break;
        case 2:
          _title = "Pokemons Favoritos";
          break;
      }
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.appBar(_title),
      body: Center(
        child: _widgets!.elementAt(_selectedTab),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Todos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Pesquise',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          )
        ],
        currentIndex: _selectedTab,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.blueAccent,
        onTap: _onTabSelected,
        backgroundColor: Colors.amber,
      ),
    );
  }
}
