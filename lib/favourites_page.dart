import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';
import 'models/saving.dart';


class FavouritesPage extends StatefulWidget {
  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}


class _FavouritesPageState extends State<FavouritesPage> {
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    final saving = Provider.of<Saving>(context);
    final Iterable<ListTile> tiles = saving.saved.map((WordPair pair) {
      return ListTile(
          title: Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.red,
            onPressed: () => saving.remove(pair),
          ));
    });

    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Suggestions'),
      ),
      body: ListView(children: divided),
    );
  }
}
