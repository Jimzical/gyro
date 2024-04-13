// ignore_for_file: avoid_print

import 'dart:async';
import 'package:sensors/sensors.dart';

class GyroscopeHandler {
  late StreamSubscription<GyroscopeEvent> _streamSubscription;
  double _angleX = 0.0, _angleY = 0.0, _angleZ = 0.0;
  DateTime? _previousTimestamp;
  final bool Function() _shouldPrintAngles;

 // Create a stream controller to emit angle data
  final _angleStreamController = StreamController<Map<String, double>>.broadcast();


  GyroscopeHandler(this._shouldPrintAngles);

  void initialize() {
    _streamSubscription = gyroscopeEvents.listen(_handleGyroscopeData);
  }

  void dispose() {
    _streamSubscription.cancel();
  }

  void _handleGyroscopeData(GyroscopeEvent event) {
    double x = event.x;
    double y = event.y;
    double z = event.z;

    final currentTimestamp = DateTime.now();
    final dt = _previousTimestamp == null
        ? 0.0
        : currentTimestamp.difference(_previousTimestamp!).inMicroseconds / 1000000;

    _angleX += x * dt;
    _angleY += y * dt;
    _angleZ += z * dt;

    _previousTimestamp = currentTimestamp;

    if (_shouldPrintAngles()) {
      // print('Angles: x = ${_angleX.toStringAsFixed(1)}, y = ${_angleY.toStringAsFixed(1)}');
          
      // Emit the angle data to the stream
      _angleStreamController.sink.add({'x': _angleX, 'y': _angleY, 'z': _angleZ});

    }

  }
  // Provide a getter to access the angle stream
  Stream<Map<String, double>> get angleStream => _angleStreamController.stream;
}