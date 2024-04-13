// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'gyroscope_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Gyroscope Example',
      home: OrientationTracker(),
    );
  }
}

class OrientationTracker extends StatefulWidget {
  const OrientationTracker({super.key});

  @override
  _OrientationTrackerState createState() => _OrientationTrackerState();
}


class _OrientationTrackerState extends State<OrientationTracker> {
  late final GyroscopeHandler _gyroscopeHandler;
  bool _shouldPrintAngles = false;

  @override
  void initState() {
    super.initState();
    _gyroscopeHandler = GyroscopeHandler(() => _shouldPrintAngles);
    _gyroscopeHandler.initialize();
  }

  @override
  void dispose() {
    _gyroscopeHandler.dispose();
    super.dispose();
  }

  void _togglePrintAngles(bool value) {
    setState(() {
      _shouldPrintAngles = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gyroscope Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Switch(
              value: _shouldPrintAngles,
              onChanged: _togglePrintAngles,
            ),
            const SizedBox(height: 16),
            const Text('Toggle to print/stop printing angles'),
            const SizedBox(height: 16),
            StreamBuilder<Map<String, double>>(
              stream: _gyroscopeHandler.angleStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final angleData = snapshot.data!;
                  return Text(
                    'X: ${angleData['x']!.toStringAsFixed(1)}\nY: ${angleData['y']!.toStringAsFixed(1)}\nZ: ${angleData['z']!.toStringAsFixed(1)}',
                    style: const TextStyle(fontSize: 18),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}