import 'package:flutter/material.dart';
import 'package:startups/home_page.dart';
import 'package:provider/provider.dart';
import 'package:startups/models/saving.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Saving(),
      child: MaterialApp(
          title: 'Startup Name Generator',
          theme: ThemeData(primaryColor: Colors.white),
          home: HomePage()),
    );
  }
}
