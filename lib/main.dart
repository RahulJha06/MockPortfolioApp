import 'package:flutter/material.dart';
import 'package:portfolio_monitor/view_models/portfolio.dart';
import 'package:portfolio_monitor/views/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Portfolio(),
      builder: (_, child) => child,
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Portfolio Tracker'),
          ),
          body: Home(),
        ),
      ),
    );
  }
}
