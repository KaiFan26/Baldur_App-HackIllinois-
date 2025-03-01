import 'package:flutter/material.dart';
import 'dart:async';
import 'stats_page.dart';
import 'session.dart';
import 'about_us.dart';
import 'package:claw_app/timer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baldur',
      theme: ThemeData(
        // Theme of the application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Baldur'),
    );
  }
}

class AnimatedRoundButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const AnimatedRoundButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  _AnimatedRoundButtonState createState() => _AnimatedRoundButtonState();
}

class _AnimatedRoundButtonState extends State<AnimatedRoundButton> {
  Color _buttonColor = Colors.blue[600]!;
  double _scale = 1.0; // Default scale

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _buttonColor = Colors.blue[800]!;
      _scale = 0.9;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _buttonColor = Colors.blue[600]!;
      _scale = 1.0; // Restore original size
    });
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() {
      _buttonColor = Colors.blue[600]!;
      _scale = 1.0; // Restore original size if tap is canceled
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Transform.scale(
        scale: _scale, // Smooth shrinking effect
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _buttonColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(widget.icon, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}

// Configuration for the state
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // Holds the values (title) provided by the parent (App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isOn = false, firstTime = true;
  Timer? timer;
  int currTime = 0;
  double _scale = 1.0;
  int debrisCount = 0;
  int _selectedIndex = 0;
  List<Session> sessionHistory = []; // Store multiple sessions

  void _startStopwatch() {
    setState(() {
      currTime = 0; // Reset elapsed time
    });
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currTime++; // Increment every second
      });
    });
  }

  void _toggleMode() {
    setState(() {
      isOn = !isOn;  // Toggle the state
      if (isOn) {
        _startStopwatch();  // Start stopwatch when turned on
      } else {
        timer?.cancel();   // Stop stopwatch when turned off
        sessionHistory.add(Session(duration: currTime, debrisCount: debrisCount));
        debrisCount = 0;  // Reset debris count when turned off
      }
    });
  }

  String _displayTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString()
        .padLeft(2, '0')}";
  }

  String _getTime() {
    if (isOn) {
      return "Current Session: \n${_displayTime(currTime)}";
    }
    else if (firstTime && !isOn) {
      firstTime = !firstTime;
      return "No Session Running";
    }
    else {
      return "Last Session: \n${_displayTime(currTime)}";
    }
  }

  String _getDebrisData() {
    return isOn ? "Debris removed: $debrisCount" : "";
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.9;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0; // Restore original size
    });
    _toggleMode();
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0; // Restore original size if tap is canceled
    });
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double value = 50; // Default value
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Adjust Scanning Range"),
              content: Column(
                mainAxisSize: MainAxisSize.min, // make window small
                children: [
                  Slider(
                    value: value,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: value.round().toString(),
                    onChanged: (double newValue) {
                      setState(() {
                        value = newValue;
                      });
                    },
                  ),
                  Text("Current Range: ${value.round()}"),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Close"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildRoundButton(IconData icon, Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,  // Adjust size
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 1) { // If "Stats" tab is clicked, navigate to StatsPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => StatsPage(sessions: sessionHistory)),
      );
    }
    else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AboutUs()),
      );
    }
    else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }


  Widget _toTimePage(IconData icon, Color color, BuildContext context) {

    return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyTimePage(title: 'Timer Page')),
      );
    },

      child: Container(
        width: 60,  // Adjust size
        height: 60,
        decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
        BoxShadow(
        color: Colors.black26,
        blurRadius: 4,
        spreadRadius: 2,
        ),
        ],
        ),
        child: Icon(icon, color: Colors.white, size: 30),
        ),
    );

  }




  @override
  Widget build(BuildContext context) {
    Color outerBorderColor = isOn ? Colors.blue : Colors.grey;
    // Rerun every time setState is called
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Take value from MyHomePage object that was created by App.build() to set appbar title
        title: Text(widget.title),
      ),
      // Layout widget that takes a single child and positions it in the middle of the parent.
      body: Center(
        // Layout widget, takes a list of children and arranges them vertically
        child: Column(
          // Center the children vertically
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Text( // Display Running Time
              _getTime(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 50), // Spacing between text and main control button
            // Center Button (Main Control)
            AnimatedScale(
              scale: _scale,
              duration: Duration(milliseconds: 100),
              child: GestureDetector(
                // Functions for button tap
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,

                child: Container( // Outer Thicker Circle
                  padding: EdgeInsets.all(4),  // Control outer spacing
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: outerBorderColor,  // Dynamic color for outer border
                      width: 10,  // Width for outer thicker circle
                    ),
                  ),

                  child: Container( // Inner Circle
                    padding: EdgeInsets.all(20),  // Control the spacing around the image
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blueAccent,  // Static color for inner circle
                        width: 3,  // Static thickness for inner circle
                      ),
                    ),

                    child: Image.asset( // Boulder Image
                      'images/clawPic.png',
                      width: 220,
                      height: 210,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 50), // Spacing between main control and side control

            Row( // Side Control Buttons
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _toTimePage(Icons.timer, Colors.blue, context),
                SizedBox(width: 40),  // Space between buttons

                AnimatedRoundButton(
                  icon: Icons.radar,
                  onPressed: () {
                    _showDialog(context);
                  },
                ),

                SizedBox(width: 40),  // Space between buttons

                AnimatedRoundButton(
                  icon: Icons.restore_from_trash,
                  onPressed: () {
                    setState(() {
                      if (isOn) {
                        debrisCount++;
                      }
                    });
                  },
                ),
              ],
            ),

            SizedBox(height: 50), // Spacing between side control and data text

            Text( // Display Data
              _getDebrisData(),
              // "Debris removed: $debrisCount",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Stats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "About Us",
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );

  }
}
