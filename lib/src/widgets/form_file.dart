import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FormPage extends StatefulWidget {
  final String ipAddress;

  const FormPage({super.key, required this.ipAddress});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TextEditingController _forwardDistanceController = TextEditingController();
  final TextEditingController _turnWidthController = TextEditingController();
  final TextEditingController _numberOfRowsController = TextEditingController();
  final TextEditingController _firstTurnController = TextEditingController();

  bool isMoving = false;
  double remainingDistance = 0.0;
  double totalDistanceInMeters = 0.0;
  double distanceCovered = 0.0;
  Timer? _moveTimer;

  // Additional variables for turn logic
  int totalRows = 0;
  String firstTurn = ''; // 'left' or 'right'
  double turnWidth = 0.0;
  bool shouldTurn = false; // To determine when to make the turn

  // Send command to device
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

  void _stopCommand({String stopCommand = '/stop'}) {
    _sendCommand(stopCommand); // Send stop command
  }

  void _startAutomation() {
    // Parsing values from controllers safely
    totalDistanceInMeters = double.tryParse(_forwardDistanceController.text) ?? 0.0;
    remainingDistance = totalDistanceInMeters * 100; // Convert to centimeters
    distanceCovered = 0.0;

    // Additional input for turn logic
    totalRows = int.tryParse(_numberOfRowsController.text) ?? 0; // Rows input
    firstTurn = _firstTurnController.text.toLowerCase(); // 'left' or 'right'
    turnWidth = double.tryParse(_turnWidthController.text) ?? 0.0; // Set the turn width in cm

    if (remainingDistance > 0) {
      setState(() {
        isMoving = true;
      });
      snackBarOverlay("Automation started", context);
      _moveForward();
    }
  }

  void _moveForward() {
    if (remainingDistance <= 0) {
      _stopMoving();
      return;
    }

    // Perform forward motion
    _sendCommand('/forward');
    remainingDistance -= 5; // Move forward by 5 cm
    distanceCovered += 5; // Update distance covered

    // After moving forward for 1 second (5 cm)
    _moveTimer = Timer(const Duration(seconds: 1), () {
      // Repeat the forward movement
      if (shouldTurn) {
        _makeTurn(); // Make turn if required
      } else {
        _moveForward(); // Keep moving forward
      }
    });

    // After each forward movement, check if the rows should change
    if (distanceCovered >= totalRows * 100) { // If rows completed
      _stopMoving();
    }

    // Set the flag to make the first turn after the forward movement
    if (distanceCovered >= 100) {
      shouldTurn = true;
    }
  }

  void _makeTurn() {
    // Calculate the time to wait for the turn (width in cm) and apply it
    double timeForTurn = turnWidth / 5; // 5 cm per second

    // Send turn command
    _sendCommand('/$firstTurn');

    // Wait for the turn to complete
    Timer(Duration(seconds: timeForTurn.toInt()), () {
      _sendCommand('/stop'); // Stop after turn
      // Switch to the opposite direction for the next turn
      firstTurn = (firstTurn == 'right') ? 'left' : 'right';

      // After the turn, resume forward movement
      shouldTurn = false; // Reset the turn flag
      _moveForward(); // Continue moving forward
    });
  }

  void _stopMoving() {
    _moveTimer?.cancel();
    setState(() {
      isMoving = false;
    });
    _sendCommand('/stop');
    snackBarOverlay("Automation stopped", context);
    print("Stopped moving.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Automation Form'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _forwardDistanceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter forward distance in meters',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _turnWidthController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter turn width in cm',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _numberOfRowsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter number of rows',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _firstTurnController,
                decoration: InputDecoration(
                  labelText: 'Enter first turn (left/right)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isMoving ? null : _startAutomation,
                child: Text(isMoving ? 'Running...' : 'Start Automation'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _stopMoving,
                child: const Text('Stop Automation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// SnackBar helper function
void snackBarOverlay(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ),
  );
}
