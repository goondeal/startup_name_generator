import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:english_words/english_words.dart';


class Saving with ChangeNotifier{
  // it is just a class with some methods to read from
  // and write to the saving file.

  final Set<WordPair> saved = Set();

  void add(WordPair wp){
    saved.add(wp);
    notifyListeners();
  }
  
  void remove(WordPair wp){
    saved.remove(wp);
    notifyListeners();
  }

  bool isSaved(WordPair wp) => saved.contains(wp);

  void loadSaved(){
    readSaved().then((res) {
      if (res.isNotEmpty) {
      processFromRead(res).forEach((wp) => saved.add(wp));
      }
      notifyListeners();
    }).catchError((e) {
      print(e.toString());
    });
  }

  void saveSaved(){
    final res = processToWrite(saved);
    writeSaved(res);
    notifyListeners();
    print('from didChangeAppLifecycleState() method: _saved saved ');
  }

  // private method its function is to get the path of the app storage folder
  Future<String> get _localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/db.txt');
  }

  Future<String> readSaved() async {
    try {
      final file = await _localFile;
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
          .replaceAll(RegExp(r"\s+\b|\b\s"), "") //remove all spaces
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
    final file = await _localFile;
    return file.writeAsString(saved);
  }

}