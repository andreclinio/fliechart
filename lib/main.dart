import 'package:flutter/material.dart';

import 'PieChartPainter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlieChart Canvas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Page"),
      ),
      body: Container(
        width: 300,
        height: 300,
        child: CustomPaint(
          painter: PieChartPainter(),
          child: Container(),
        ),
      ),
    );
  }
}
