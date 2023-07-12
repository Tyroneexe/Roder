import 'package:cloud_firestore/cloud_firestore.dart';
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
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('rides').snapshots(),
            builder: (context, snapshot) {
              List<Row> rideWidgets = [];
              if (snapshot.hasData) {
                final rides = snapshot.data?.docs.reversed.toList();
                for (var ride in rides!) {
                  final rideWidget = Row(
                    children: [
                      Text(
                        ride['Name'],
                      ),
                    ],
                  );
                  rideWidgets.add(rideWidget);
                }
              }
              return Expanded(
                child: ListView(
                  children: rideWidgets,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
