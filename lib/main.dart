import 'package:fliechart/chart-callbacks.dart';
import 'package:fliechart/chart-descriptor-demo.dart';
import 'package:fliechart/slice-descriptor.dart';
import 'package:flutter/material.dart';

import 'chart-widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlieChart Canvas Demo',
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
      appBar: AppBar(title: Text("FlieChart Demo Page")),
      body: Container(
        child: _buildListView(context),
      ),
    );
  }

  Widget _buildListView(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(leading: Text("Demo " + index.toString()), title: _buildChatDemo(context));
        });
  }

  Widget _buildChatDemo(BuildContext context) {
    return PieChart(
      descriptor: PieChartDemoDescriptor(),
      callbacks: PieChartCallbacks(tappedSlice: _x),
    );
  }

  void _x(List<ISliceDescriptor> all, ISliceDescriptor s) {
    setState(() {
      all.forEach((s) {
        final slice = s as SliceDescriptor;
        slice.color = Colors.white;
      });
      final slice = s as SliceDescriptor;
      slice.color = Colors.red;
    });
  }
}
