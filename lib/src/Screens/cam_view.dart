import 'dart:async';
import 'package:flutter/cupertino.dart';
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
      snackBarOverlay("Automation activated", context);

      isMoving = true;
      _moveForward();
    }
  }

  void _moveForward() {
    if (remainingDistance <= 0) {
      _stopMoving();
      return;
    }

    _sendCommand('/forward');
    remainingDistance -= 5;
    distanceCovered += 5;

    if (distanceCovered % 100 == 0) {
      snackBarOverlay("${(distanceCovered / 100).floor()} meter covered.", context);
    }

    _moveTimer = Timer(const Duration(seconds: 1), () {
      _moveForward();
    });
  }

  void _stopMoving() {
    _moveTimer?.cancel();
    isMoving = false;
    _sendCommand('/stop');
    snackBarOverlay("Automation deactivated", context);
    print("Stopped moving.");
  }

  void _toggleAutopilot() {
    if (isMoving) {
      _stopMoving();
    } else {
      _startMoving();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Row(
        children: [
          // Garden Part
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                Positioned(
                  top: 20,
                  left: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey, // Grey color for the button
                      shape: BoxShape.circle, // Circular shape
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5), // Dark shadow for the 3D effect
                          offset: const Offset(4, 4), // Shadow offset
                          blurRadius: 6, // Shadow blur radius
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2), // Light shadow for 3D effect
                          offset: const Offset(-4, -4), // Light shadow offset
                          blurRadius: 6, // Light shadow blur radius
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(5), // Padding around the icon
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white), // Icon in white color
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),

                Padding(
                  
                  padding: const EdgeInsets.only(left: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF7F7F7F), // Light grey gradient
                                Colors.white, // White gradient
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20.0), // Rounded edges for 3D effect
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                offset: Offset(4, 4),
                                blurRadius: 4,
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.2),
                                offset: Offset(-4, -4),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _distanceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Enter distance in meters',
                              labelStyle: TextStyle(color: Colors.black, fontSize: 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              // Remove default background
                              fillColor: Colors.transparent, // Ensuring gradient is visible
                            ),
                            style: TextStyle(color: Colors.black), // Text color
                          ),
                        ),
                      ),

                      for (int row = 0; row < 9; row++) // Number of rows
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            10, // Number of columns
                                (col) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: ((col ~/ 2) % 2 == 0)
                                      ? Colors.green[700]
                                      : Colors.brown[400],
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    const BoxShadow(
                                      color: Colors.black38,
                                      blurRadius: 4,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                )


                // Center(
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Container(
                //         width: 4,
                //         height: screenHeight * 0.4,
                //         color: Colors.brown,
                //         margin: EdgeInsets.symmetric(vertical: 20),
                //       ),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: List.generate(
                //           8,
                //               (index) => Padding(
                //             padding: const EdgeInsets.symmetric(horizontal: 4),
                //             child: Container(
                //               width: 20,
                //               height: 20,
                //               decoration: BoxDecoration(
                //                 color: Colors.green[700],
                //                 shape: BoxShape.circle,
                //                 boxShadow: [
                //                   BoxShadow(
                //                     color: Colors.black38,
                //                     blurRadius: 4,
                //                     offset: Offset(2, 2),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //       SizedBox(height: 20),
                //       Text(
                //         'Crop Row',
                //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
          // Control Part
          Expanded(
            flex: 1,
            child:
            Column(
              children: [
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey, // Background color for the button
                        shadowColor: Colors.black, // Shadow color for the 3D effect
                        elevation: 5, // Elevation to create the 3D shadow effect
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0), // Rounded corners
                        ),
                        padding: EdgeInsets.zero, // Reset outer padding for consistent size
                      ),
                      onPressed: _toggleAutopilot,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Increased padding
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF7F7F7F), // Light grey gradient
                              Colors.white, // White gradient
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(4, 4),
                              blurRadius: 4,
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.2),
                              offset: const Offset(-4, -4),
                              blurRadius: 4,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20.0), // Border radius for the button
                        ),
                        child: const Text(
                          'Autopilot',
                          style: TextStyle(
                            color: Colors.black, // White text color
                            fontWeight: FontWeight.w400, // Slightly light font weight
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey, // Same grey background
                        shadowColor: Colors.black, // Shadow for 3D effect
                        elevation: 5, // Consistent elevation for both buttons
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0), // Rounded corners
                        ),
                        padding: EdgeInsets.zero, // Reset outer padding
                      ),
                      onPressed: _stopMoving,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Padding for text
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF7F7F7F), // Light grey gradient
                              Colors.white, // White gradient
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(4, 4),
                              blurRadius: 4,
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.2),
                              offset: const Offset(-4, -4),
                              blurRadius: 4,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20.0), // Rounded corners for the button
                        ),
                        child: const Text(
                          'Stop',
                          style: TextStyle(
                            color: Colors.black, // White text color
                            fontWeight: FontWeight.w400, // Slightly light font weight
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height:20 ,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildControlButton(Icons.keyboard_arrow_up_sharp, "/go"),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildControlButton(Icons.arrow_back_ios_new, "/left"),
                    const SizedBox(width: 10),

                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF7F7F7F),
                        shape: BoxShape.circle,
                        boxShadow: [
                          const BoxShadow(color: Colors.white, offset: Offset(2, 2), blurRadius: 6),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: const Icon(Icons.grass, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 10,),
                    _buildControlButton(Icons.arrow_forward_ios, "/right"),
                  ],
                ),

                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildControlButton(Icons.keyboard_arrow_down, "/back"),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),

          ),
        ],
      ),
    );
  }

  Widget _build3DButton(String label, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 8,
        shadowColor: Colors.black45,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildControlButton(IconData icon, String command) {
    return GestureDetector(
      onTapDown: (_) => _sendCommand(command),
      onTapUp: (_) => _stopMoving(),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF7F7F7F),
          shape: BoxShape.circle,
          boxShadow: [
            const BoxShadow(color: Colors.black, offset: Offset(3, 3), blurRadius: 6),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
