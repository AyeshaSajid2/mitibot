import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/AutomationControlsWidget.dart';
import '../widgets/ManualControlsWidget.dart';
import '../widgets/snackbar.dart';

class MonitoringPage extends StatefulWidget {
  final String ipAddress;

  const MonitoringPage({Key? key, required this.ipAddress}) : super(key: key);

  @override
  _MonitoringPageState createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  final TextEditingController _distanceController = TextEditingController();
  bool isMoving = false;
  double remainingDistance = 0.0;
  double totalDistanceInMeters = 0.0;
  double distanceCovered = 0.0;
  Timer? _moveTimer;
  double motorSpeed = 50.0; // Default motor speed

  Future<void> _sendCommand(String command) async {
    try {
      final response = await http.get(Uri.parse('http://${widget.ipAddress}$command'));
      if (response.statusCode == 200) {
        print('Command sent successfully: $command');
      } else {
        print('Failed to send command: $command');
      }
    } catch (error) {
      print('Error sending command: $command, $error');
    }
  }

  void _startMoving() {
    totalDistanceInMeters = double.tryParse(_distanceController.text) ?? 0.0;
    remainingDistance = totalDistanceInMeters * 100; // Convert to centimeters
    distanceCovered = 0.0;
    if(totalDistanceInMeters == 0.0 || totalDistanceInMeters < 0)
      {
        snackBarOverlay("Enter distance to start automation", context);;

        setState(() {
          isMoving = true;
        });
      }
    else if (remainingDistance > 0) {
      snackBarOverlay("Automation activated", context);;

      setState(() {
        isMoving = true;
      });
      _moveForward();
    }
  }

  void _moveForward() {
    if (remainingDistance <= 0) {
      _stopMoving();
      return;
    }

    _sendCommand('/forward');
    setState(() {
      remainingDistance -= 5;
      distanceCovered += 5;
    });

    if (distanceCovered % 100 == 0) {
      snackBarOverlay("${(distanceCovered / 100).floor()} meters covered.", context);;
    }

    _moveTimer = Timer(const Duration(seconds: 1), _moveForward);
  }

  void _moveInDirection(String direction) {
    _sendCommand('/$direction');
    snackBarOverlay("Automation started", context);

    Timer(const Duration(seconds: 5), () {
      _sendCommand('/stop');
      snackBarOverlay("Automation completed", context);
    });
  }

  void _stopMoving() {
    _moveTimer?.cancel();
    setState(() {
      isMoving = false;
    });
    _sendCommand('/stop');
    snackBarOverlay("Automation deactivated", context);
    print("Stopped moving.");
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // SizedBox(),
              Row(
                children: [
                  Expanded(
                    child: ManualControlsWidget(
                      onSendCommand: _sendCommand,
                    ),
                  ),
                  Expanded(
                    child: AutomationControlsWidget(
                      onSendCommand: _sendCommand,
                      startMoving: _startMoving,
                      stopMoving: _stopMoving,
                      distanceController: _distanceController,
                      onLeftMove: () => _moveInDirection('left'),
                      onRightMove: () => _moveInDirection('right'),
                    ),

                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
              const Text("Motor Speed", style: TextStyle(fontSize: 20)),
              Slider(
                value: motorSpeed,
                min: 0,
                max: 100,
                divisions: 10,
                label: motorSpeed.round().toString(),
                onChanged: (value) {
                  setState(() {
                    motorSpeed = value;
                  });
                  _sendCommand('/speed?value=${value.toInt()}');
                },
              ),
              Text(
                "Current Speed: ${motorSpeed.round()}%",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
