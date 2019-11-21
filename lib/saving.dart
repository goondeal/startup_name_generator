import 'dart:io';
import 'dart:async';

//import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:english_words/english_words.dart';

//final String pathSuffix = 'startup/storage';

class Saving {
  // it is just a class with some methods to read from
  // and write to the saving file.

  // private method its function is to get the path of the app storage folder

  Future<String> get localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/db.txt');
  }

  Future<String> readSaved() async {
    try {
      final file = await localFile;
      String body = await file.readAsString();
      return body;
    } catch (e) {
      return '';
    }
  }

  Set<WordPair> processFromRead(String read) {
    try {
      return read
          .substring(1, read.length - 1)
          .replaceAll(RegExp(r"\s+\b|\b\s"), "")
          .split(',')
          .map((s) => WordPair(s, ' '))
          .toSet();
    } catch (e) {
      print('from: processFromRead' + e.toString());
    }
  }

  String processToWrite(Set<WordPair> saved) {
    // refactor the set of word pairs to a string
    return saved
        .map((wp) => wp.asString)
        .toSet()
        .toString()
        .replaceAll(RegExp(r"\s+\b|\b\s"), "");
  }

  Future<File> writeSaved(String saved) async {
    final file = await localFile;
    print('write to file');
    return file.writeAsString(saved);
  }
}
// Fluttertoast.showToast(
//           msg: "_saved loaded $_saved",
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.CENTER,
//           timeInSecForIos: 1,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//           fontSize: 16.0);
