import 'dart:convert';

import 'package:dockerflutter/pages/InfoClonePage.dart';
import 'package:dockerflutter/pages/todoClonePage.dart';
import 'package:dockerflutter/providers/todoProvider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(home: Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: TextButton(
                child: Text("01. TODO"),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) => ChangeNotifierProvider<TodoProvider>(
                    create: (BuildContext context) => TodoProvider(),
                    child: TodoClonePage())
                  )
                ),
              ),
            ),
            Container(
              child: TextButton(
                child: Text("02. Info"),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) => InfoClonePage())
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}

