import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uri/uri.dart';
import 'package:tu_wien_adressbook/models/person.dart';
import 'package:tu_wien_adressbook/models/tiss.dart';
import 'package:tu_wien_adressbook/widgets/person_card.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TU Addressbook',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'TU Addressbook'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Person person = Person.example();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                Person p = await showSearch(
                    context: context, delegate: PersonSearch());
                setState(() {
                  person = p;
                });
              })
        ],
      ),
      body: PersonScreen(person),
    );
  }
}

class PersonSearch extends SearchDelegate<Person> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var template = new UriTemplate(
        "https://tiss.tuwien.ac.at/api/person/v22/psuche?q={query}&max_treffer=50&intern=true");
    String apiUri = template.expand({'query': query});
    Future<http.Response> response = http.get(apiUri);

    return FutureBuilder<http.Response>(
        future: response,
        builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
          // Check if the data is ready
          if (!snapshot.hasData) {
            return Center(child: Text("Loading..."));
          }

          // Check if the server answered successfully
          http.Response resp = snapshot.data;
          if (resp.statusCode != 200) {
            return Center(child: Text("Failed to load data from the server"));
          }

          // Decode the json
          var map = jsonDecode(resp.body);
          Tiss data = Tiss.fromJson(map);

          return ListView.builder(
              itemCount: data.results.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: PersonCard(data.results[index]),
                  onTap: () {
                    close(context, data.results[index]);
                  },
                );
              });
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(child: Text('Suggestions are not yet implemented.'));
  }
}