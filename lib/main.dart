import 'package:flutter/material.dart';
import 'package:new_demo/Widgets/TopStoriesPage.dart';

import 'DataModel/Stories.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'News Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

   int present = 0;
   int perPage = 15;
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('News Demo'),
        ),
        body: NewsPage(story: Stories.top)
      ),
    );
  }
}
