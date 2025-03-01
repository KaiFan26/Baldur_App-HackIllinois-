import 'package:flutter/material.dart';
import 'session.dart'; // Import the Session class

class StatsPage extends StatelessWidget {
  final List<Session> sessions;

  const StatsPage({super.key, required this.sessions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("📊 Stats Page")),
      body: sessions.isEmpty
        ? Center(child: Text("No sessions recorded", style: TextStyle(fontSize: 20)))
        : Scrollbar( // <-- Add this
          thumbVisibility: true, // Makes scrollbar always visible
          thickness: 8.0, // Width of the scrollbar
          radius: Radius.circular(10), // Rounded edges for scrollbar
          child: ListView.builder(
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            Session session = sessions[index];
            return ListTile(
              leading: Icon(Icons.timer),
              title: Text("Session ${index + 1}: ${session.duration} sec"),
              subtitle: Text(
                  "Debris Collected: ${session.debrisCount}"),
            );
          },
          ),
        ),
    );
  }
}
