import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

    if (remainingDistance > 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Automation activated"),
        backgroundColor: Colors.green,
      ));

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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${(distanceCovered / 100).floor()} meters covered."),
        backgroundColor: Colors.blue,
      ));
    }

    _moveTimer = Timer(const Duration(seconds: 1), _moveForward);
  }

  void _moveInDirection(String direction) {
    _sendCommand('/$direction');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("$direction automation started"),
      backgroundColor: Colors.blue,
    ));

    Timer(const Duration(seconds: 5), () {
      _sendCommand('/stop');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("$direction automation completed"),
        backgroundColor: Colors.green,
      ));
    });
  }

  void _stopMoving() {
    _moveTimer?.cancel();
    setState(() {
      isMoving = false;
    });
    _sendCommand('/stop');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Automation deactivated"),
      backgroundColor: Colors.red,
    ));
    print("Stopped moving.");
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Agribot Monitoring"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Control Agribot",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => _moveInDirection('left'),
                    icon: const Icon(Icons.chevron_left, size: 36),
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: width * 0.5,
                    child: TextField(
                      controller: _distanceController,
                      decoration: InputDecoration(
                        labelText: "Row length (m)",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _moveInDirection('right'),
                    icon: const Icon(Icons.chevron_right, size: 36),
                    color: Colors.blue,
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _startMoving,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("Start Automation"),
                  ),
                  ElevatedButton(
                    onPressed: _stopMoving,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text("Stop"),
                  ),
                ],
              ),
              SizedBox(height: height * 0.03),
              const Text(
                "Manual Controls",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () => _sendCommand('/left'),
                    icon: const Icon(Icons.arrow_left, size: 36),
                    color: Colors.blue,
                  ),
                  IconButton(
                    onPressed: () => _sendCommand('/forward'),
                    icon: const Icon(Icons.arrow_upward, size: 36),
                    color: Colors.green,
                  ),
                  IconButton(
                    onPressed: () => _sendCommand('/right'),
                    icon: const Icon(Icons.arrow_right, size: 36),
                    color: Colors.blue,
                  ),
                ],
              ),
              IconButton(
                onPressed: () => _sendCommand('/reverse'),
                icon: const Icon(Icons.arrow_downward, size: 36),
                color: Colors.orange,
              ),
              SizedBox(height: height * 0.03),
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
              SizedBox(height: height * 0.04),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatusDot(color: isMoving ? Colors.green : Colors.brown),
                  SizedBox(width: width * 0.02),
                  _buildStatusDot(color: isMoving ? Colors.green : Colors.brown),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusDot({required Color color}) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
