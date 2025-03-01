import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isOn = false;
  Timer? timer;
  int currTime = 0;
  bool firstTime = true;

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

  void _toggleTime() {
    setState(() {
      isOn = !isOn;  // Toggle the state
      if (isOn) {
        _startStopwatch();  // Start stopwatch when turned on
      } else {
        timer?.cancel();   // Stop stopwatch when turned off
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
    } else if (firstTime && !isOn) {
      firstTime = !firstTime;
      return "";
    }
    else {
      return "Last Session: \n${_displayTime(currTime)}";
    }
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

  @override
  Widget build(BuildContext context) {
    Color outerBorderColor = isOn ? Colors.blue : Colors.grey;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(

        // Center is a layout widget. It takes a sngle child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _getTime(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50),
            GestureDetector(
              onTap: _toggleTime,
              child: Container(
                padding: EdgeInsets.all(4),  // Adjust this value to control the outer spacing
                decoration: BoxDecoration( //OUTER THICKER CIRCLE
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: outerBorderColor,  // Use the dynamic color for the outer border
                    width: 10,  // Width for the outer thicker circle
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(20),  // Adjust this value to control the spacing around the image
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blueAccent,  // Static color for the inner circle
                      width: 3,  // Static thickness for the inner circle
                    ),
                  ),
                  child: Image.asset(
                    'images/clawPic.png',
                    width: 220,
                    height: 210,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildRoundButton(Icons.alarm, Colors.blue, () {
                }),
                SizedBox(width: 40),  // Space between buttons
                _buildRoundButton(Icons.radar, Colors.blue, () {
                }),
                SizedBox(width: 40),  // Space between buttons
                _buildRoundButton(Icons.restore_from_trash, Colors.blue, () {
                }),
              ],
            ),
            SizedBox(height: 50),
            Text(
              "Debris removed: ",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
     // This trailing comma makes auto-formatting nicer for build methods.
    );

  }
}
