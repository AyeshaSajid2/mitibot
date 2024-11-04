import 'dart:async';
import 'package:back_pressed/back_pressed.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../router_helper.dart';
import '../widgets/snackbar.dart';

class MonitoringPage extends StatefulWidget {
  final String ipAddress;

  const MonitoringPage({super.key, required this.ipAddress});

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

  void _startMoving() {
    totalDistanceInMeters = double.tryParse(_distanceController.text) ?? 0.0;
    remainingDistance = totalDistanceInMeters * 100; // Convert to centimeters
    distanceCovered = 0.0;

    if (remainingDistance > 0) {
      // Show overlay snackbar
     snackBarOverlay("Automation activated", context);

      isMoving = true;
      _moveForward();
    }
  }

  void _moveForward() {
    if (remainingDistance <= 0) {
      _stopMoving(); // Stop if no distance remaining
      return;
    }

    _sendCommand('/forward');
    remainingDistance -= 5; // Move forward by 5 cm
    distanceCovered += 5; // Update distance covered

    // Check if a meter has been covered
    if (distanceCovered % 100 == 0) {
      snackBarOverlay("${(distanceCovered / 100).floor()} meter covered.", context);
    }

    // Move for 1 second for every 5 cm
    _moveTimer = Timer(const Duration(seconds: 1), () {
      // After 1 second, check remaining distance
      _moveForward();
    });
  }

  void _stopMoving() {
    _moveTimer?.cancel(); // Cancel the timer
    isMoving = false;
    _sendCommand('/stop');
    // Send stop command
    snackBarOverlay("Automation deactivated", context);
    print("Stopped moving.");
    // Handle any additional logic if needed
  }

  void _toggleAutopilot() {
    if (isMoving) {
      _stopMoving(); // If moving, stop it
    } else {
      _startMoving(); // If not moving, start it
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnBackPressed(
      perform: () => Routes.pushNamedAndRemoveUntil(Routes.home),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: <Widget>[
            // Back Button
            Positioned(
              top: 20,
              left: 20,
              child: GestureDetector(
                onTap: () => Routes.pushNamedAndRemoveUntil(Routes.home),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 32.0,
                  ),
                ),
              ),
            ),
            // Autopilot Button
            Positioned(
              top: 20,
              right: 20,
              child: GestureDetector(
                onTap: _toggleAutopilot, // Toggle between moving and stopping
                child: Container(
                  decoration: BoxDecoration(
                    color: isMoving ? Colors.white : Colors.black,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: isMoving ? Colors.black : Colors.white,
                      width: 2.0,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    isMoving ? 'Stop' : 'Autopilot',
                    style: TextStyle(
                      color: isMoving ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // Text Editing Controller
            Positioned(
              top: 50,
              right: (MediaQuery.of(context).size.width / 2 - 100),
              child: SizedBox(
                width: 200, // Reduce width if needed
                child: TextField(
                  controller: _distanceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter distance in meters',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 14), // Reduce font size
                ),
              ),
            ),
            // Weed Button
            Positioned(
              bottom: 30,
              left: 20,
              child: _buildWeedButton(),
            ),
            // Control Buttons
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 20, // Center vertically
              left: MediaQuery.of(context).size.width / 2 - 50, // Center horizontally
              child: _buildControlButtons(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeedButton() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTapDown: (_) => _sendCommand('/ledon'),  // Start command for LED ON
        onTapUp: (_) => _stopCommand(stopCommand: '/ledoff'),  // Stop command for LED OFF
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2.0,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: const Icon(
            Icons.electric_bolt_sharp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildControlButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(Icons.arrow_upward, "/go"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(Icons.arrow_back, "/left"),
            const SizedBox(width: 45),
            _buildButton(Icons.arrow_forward, "/right"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(Icons.arrow_downward, "/back"),
          ],
        ),
      ],
    );
  }

  // Send stop command when the button is released
  void _stopCommand({String stopCommand = '/stop'}) {
    _sendCommand(stopCommand); // Send stop command
  }

  Widget _buildButton(IconData icon, String command) {
    return GestureDetector(
      onTapDown: (_) => _sendCommand(command),
      onTapUp: (_) => _stopCommand(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Colors.white,
            width: 2.0,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
