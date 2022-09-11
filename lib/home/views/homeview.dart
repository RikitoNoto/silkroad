//ホーム画面ビュー

import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SilkRoad',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'ホーム画面'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(

        child: Column(
          children: <Widget>[
            ElevatedButton(
              child: const Text('Button1'),
              style: ElevatedButton.styleFrom(

              ),
              onPressed:() {},
            ),
            ElevatedButton(
              child: const Text('Button2'),
              style: ElevatedButton.styleFrom(

              ),
              onPressed: () {},
            ),
          ]
        ),
      ),


    );
  }
}
