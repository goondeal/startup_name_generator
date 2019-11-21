import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:english_words/english_words.dart';
//import 'package:fluttertoast/fluttertoast.dart';

import 'saving.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(primaryColor: Colors.white),
      home: RandomWords(saving: Saving()),
    );
  }
}

class RandomWords extends StatefulWidget {
  final Saving saving;
  RandomWords({Key key, @required this.saving}) : super(key: key);

  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> with WidgetsBindingObserver {
  // main route variable
  final List<WordPair> _suggestions = [];
  // favorite route variable
  Set<WordPair> _saved = Set();

  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  // load the preceding saved names from app storage file to "_saved" list
  @override
  void initState() {
    super.initState();
    widget.saving.readSaved().then((res) {
      if (res.isNotEmpty) {
        setState(() {
          widget.saving.processFromRead(res).forEach((wp) => _saved.add(wp));
        });
      }
    }).catchError((e) {
      print(e.toString());
      setState(() {
        _saved.add(WordPair('first', 'second'));
      });
    });
  }

  // save the "_saved" list of favourite names to the file
  @override
  void dispose() {
    final res = widget.saving.processToWrite(_saved);
    widget.saving.writeSaved(res);
    print('from dispose() method: _saved saved ');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }

          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
              widget.saving.writeSaved(pair.toString());
            }
          });
        });
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}
