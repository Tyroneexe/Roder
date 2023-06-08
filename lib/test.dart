import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.red,
            expandedHeight: 200,
            title: Text('Near Me'),
            leading: Icon(Icons.arrow_back_ios),
            actions: [
              Icon(Icons.settings),
              SizedBox(
                width: 12,
              ),
            ],
          )
        ],
      ),
    );
  }
}
