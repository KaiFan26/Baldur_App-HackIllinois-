import 'package:claw_app/minutes.dart';
import 'package:claw_app/seconds.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'hours.dart';
import 'tile.dart';

class MyTimePage extends StatefulWidget {
  const MyTimePage({super.key, required this.title});

  final String title;

  @override
  State<MyTimePage> createState() => _MyTimePageState();
}

class _MyTimePageState extends State<MyTimePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      backgroundColor: Colors.white,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildTimeColumn("Hours", 24, (index) => MyHours(hours: index)),
          buildTimeColumn("Minutes", 60, (index) => MyMinutes(mins: index)),
          buildTimeColumn("Seconds", 60, (index) => MySeconds(seconds: index)),
        ],
      ),


    );
  }

  Widget buildTimeColumn(String label, int childCount, Widget Function(int) builder) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)), // Label for each wheel
          Expanded(
            child: ListWheelScrollView.useDelegate(
              itemExtent: 50,
              perspective: 0.01,
              diameterRatio: 1.2,
              physics: FixedExtentScrollPhysics(),
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: childCount,
                builder: (context, index) => builder(index),
              ),
            ),
          ),
        ],
      ),


    );
  }
}
