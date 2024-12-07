// ignore_for_file: dangling_library_doc_comments
// import 'dart:async';
// import 'package:back_pressed/back_pressed.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// // Import the FormPage
// import '../router_helper.dart';
// import '../widgets/form_file.dart';
//
//
// class MonitoringPage extends StatefulWidget {
//   final String ipAddress;
//
//   const MonitoringPage({super.key, required this.ipAddress});
//
//   @override
//   _MonitoringPageState createState() => _MonitoringPageState();
// }
//
// class _MonitoringPageState extends State<MonitoringPage> {
//   final TextEditingController _distanceController = TextEditingController();
//   bool isMoving = false;
//   double remainingDistance = 0.0;
//   double totalDistanceInMeters = 0.0;
//   double distanceCovered = 0.0;
//   Timer? _moveTimer;
//
//   // Send command to device
//   Future<void> _sendCommand(String command) async {
//     try {
//       final response = await http.get(Uri.parse('http://${widget.ipAddress}$command'));
//       if (response.statusCode == 200) {
//         print('Command sent successfully: $command');
//       } else {
//         print('Failed to send command: $command');
//       }
//     } catch (error) {
//       print('Error sending command: $command, $error');
//     }
//   }
//
//   Widget _buildButton(IconData icon, String command) {
//     return GestureDetector(
//       onTapDown: (_) => _sendCommand(command),
//       onTapUp: (_) => _stopCommand(),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.black,
//           borderRadius: BorderRadius.circular(10.0),
//           border: Border.all(
//             color: Colors.white,
//             width: 2.0,
//           ),
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
//         child: Icon(
//           icon,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
//
//   void _stopCommand({String stopCommand = '/stop'}) {
//     _sendCommand(stopCommand); // Send stop command
//   }
//
//
//   void _stopMoving() {
//     _moveTimer?.cancel(); // Cancel the timer
//     isMoving = false;
//     _sendCommand('/stop');
//     // Send stop command
//     snackBarOverlay("Automation deactivated", context);
//     print("Stopped moving.");
//     // Handle any additional logic if needed
//   }
//
//   // void _toggleAutopilot() {
//   //   if (isMoving) {
//   //     _stopMoving(); // If moving, stop it
//   //   } else {
//   //     _startMoving(); // If not moving, start it
//   //   }
//   // }
//
//   // Navigate to the FormPage when the button is pressed
// // Navigate to the FormPage with the correct IP address
//   void _navigateToFormPage() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => FormPage(ipAddress: widget.ipAddress),
//       ),
//     );
//   }
//
//   Widget _buildWeedButton() {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: GestureDetector(
//         onTapDown: (_) => _sendCommand('/ledon'),  // Start command for LED ON
//         onTapUp: (_) => _stopCommand(stopCommand: '/ledoff'),  // Stop command for LED OFF
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.black,
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: Colors.white,
//               width: 2.0,
//             ),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//           child: const Icon(
//             Icons.electric_bolt_sharp,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildControlButtons() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildButton(Icons.arrow_upward, "/go"),
//           ],
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildButton(Icons.arrow_back, "/left"),
//             const SizedBox(width: 45),
//             _buildButton(Icons.arrow_forward, "/right"),
//           ],
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildButton(Icons.arrow_downward, "/back"),
//           ],
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return OnBackPressed(
//       perform: () => Routes.pushNamedAndRemoveUntil(Routes.home),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Stack(
//           children: <Widget>[
//             // Back Button
//             Positioned(
//               top: 20,
//               left: 20,
//               child: GestureDetector(
//                 onTap: () => Routes.pushNamedAndRemoveUntil(Routes.home),
//                 child: Container(
//                   decoration: const BoxDecoration(
//                     color: Colors.black,
//                     shape: BoxShape.circle,
//                   ),
//                   padding: const EdgeInsets.all(16),
//                   child: const Icon(
//                     Icons.arrow_back,
//                     color: Colors.white,
//                     size: 32.0,
//                   ),
//                 ),
//               ),
//             ),
//             // Autopilot Button
//             Positioned(
//               top: 20,
//               right: 20,
//               child: GestureDetector(
//                 // onTap: _toggleAutopilot, // Toggle between moving and stopping
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: isMoving ? Colors.white : Colors.black,
//                     borderRadius: BorderRadius.circular(20.0),
//                     border: Border.all(
//                       color: isMoving ? Colors.black : Colors.white,
//                       width: 2.0,
//                     ),
//                   ),
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   child: ElevatedButton(
//                     onPressed: _navigateToFormPage,
//                     child: const Text('Automation '),
//                   ),
//                 ),
//               ),
//             ),
//             // Button to navigate to form
//             Positioned(
//               bottom: 0,
//               right: 40,
//               child: _buildControlButtons(),
//             ),
//             // Positioned(
//             //   bottom: 50,
//             //   right: 250,
//             //   child: ElevatedButton(
//             //     onPressed: _navigateToFormPage,
//             //     child: const Text('Open Automation Form'),
//             //   ),
//             // ),
//             Positioned(
//               bottom: 30,
//               left: 20,
//               child: _buildWeedButton(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
/////  **************************************************************************//////

////import 'dart:async';
// import 'package:back_pressed/back_pressed.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../router_helper.dart';
// import '../widgets/snackbar.dart';
//
// class MonitoringPage extends StatefulWidget {
//   final String ipAddress;
//
//   const MonitoringPage({super.key, required this.ipAddress});
//
//   @override
//   _MonitoringPageState createState() => _MonitoringPageState();
// }
//
// class _MonitoringPageState extends State<MonitoringPage> {
//   final TextEditingController _distanceController = TextEditingController();
//   bool isMoving = false;
//   double remainingDistance = 0.0;
//   double totalDistanceInMeters = 0.0;
//   double distanceCovered = 0.0;
//   Timer? _moveTimer;
//
//   // Send command to device
//   Future<void> _sendCommand(String command) async {
//     try {
//       final response = await http.get(Uri.parse('http://${widget.ipAddress}$command'));
//       if (response.statusCode == 200) {
//         print('Command sent successfully: $command');
//       } else {
//         print('Failed to send command: $command');
//       }
//     } catch (error) {
//       print('Error sending command: $command, $error');
//     }
//   }
//
//   void _startMoving() {
//     totalDistanceInMeters = double.tryParse(_distanceController.text) ?? 0.0;
//     remainingDistance = totalDistanceInMeters * 100; // Convert to centimeters
//     distanceCovered = 0.0;
//
//     if (remainingDistance > 0) {
//       snackBarOverlay("Automation activated", context);
//
//       isMoving = true;
//       _moveForward();
//     }
//   }
//
//
//   void _moveForward() {
//     if (remainingDistance <= 0) {
//       _stopMoving();
//       return;
//     }
//
//     _sendCommand('/go');
//     remainingDistance -= 5;
//     distanceCovered += 5;
//
//     if (distanceCovered % 100 == 0) {
//       snackBarOverlay("${(distanceCovered / 100).floor()} meter covered.", context);
//     }
//
//     _moveTimer = Timer(const Duration(seconds: 1), () {
//       _moveForward();
//     });
//   }
//
//
//   void _stopMoving({String stopCommand = '/stop'} ) {
//     _moveTimer?.cancel();
//     isMoving = false;
//     _sendCommand(stopCommand);
//     snackBarOverlay("Automation deactivated", context);
//     print("Stopped moving.");
//   }
//
//   void _stopCommand({String stopCommand = '/stop'} ) {
//     _moveTimer?.cancel();
//     isMoving = false;
//     _sendCommand(stopCommand);
//     print("Stopped moving.");
//   }
//
//
//   void _toggleAutopilot() {
//     if (_distanceController.text.isEmpty || int.tryParse(_distanceController.text) == 0) {
//       snackBarOverlay("Enter the lenght of row to start automation", context);
//     }
//     else if (isMoving) {
//       _stopMoving();
//     } else {
//       _startMoving();
//     }
//   }
//   Widget _buildButton(double screenWidth, String label, VoidCallback onPressed) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.grey,
//         shadowColor: Colors.black,
//         elevation: 5,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
//         padding: EdgeInsets.zero,
//       ),
//       onPressed: onPressed,
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 12, horizontal: 0.05 * screenWidth),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(colors: [Color(0xFF7F7F7F), Colors.white]),
//           boxShadow: [
//             BoxShadow(color: Colors.black.withOpacity(0.5), offset: const Offset(4, 4), blurRadius: 4),
//             BoxShadow(color: Colors.white.withOpacity(0.2), offset: const Offset(-4, -4), blurRadius: 4),
//           ],
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(
//           label,
//           style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
//         ),
//       ),
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return OnBackPressed(
//       perform: () => Routes.pushNamedAndRemoveUntil(Routes.home),
//       child: Scaffold(
//         backgroundColor: Colors.grey[300],
//         body: LayoutBuilder(
//           builder: (context, constraints) {
//             final screenWidth = constraints.maxWidth;
//             final screenHeight = constraints.maxHeight;
//             final isSmallScreen = screenWidth < 600;
//
//             return Row(
//               children: [
//                 // Garden Part
//                 Expanded(
//                   flex: 1,
//                   child: Stack(
//                     children: [
//                       Positioned(
//                         top: 0.02 * screenHeight,
//                         left: 0.01 * screenWidth,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Colors.grey,
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.5),
//                                 offset: const Offset(4, 4),
//                                 blurRadius: 6,
//                               ),
//                               BoxShadow(
//                                 color: Colors.white.withOpacity(0.2),
//                                 offset: const Offset(-4, -4),
//                                 blurRadius: 6,
//                               ),
//                             ],
//                           ),
//                           padding: EdgeInsets.all(0.01 * screenWidth),
//                           child: IconButton(
//                             icon: const Icon(Icons.arrow_back, color: Colors.white),
//                             onPressed: () => Routes.pushNamedAndRemoveUntil(Routes.home),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(left: 0.05 * screenWidth),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.all(0.02 * screenWidth),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   gradient: const LinearGradient(
//                                     colors: [Color(0xFF7F7F7F), Colors.white],
//                                     begin: Alignment.topLeft,
//                                     end: Alignment.bottomRight,
//                                   ),
//                                   borderRadius: BorderRadius.circular(20),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.5),
//                                       offset: const Offset(4, 4),
//                                       blurRadius: 4,
//                                     ),
//                                     BoxShadow(
//                                       color: Colors.white.withOpacity(0.2),
//                                       offset: const Offset(-4, -4),
//                                       blurRadius: 4,
//                                     ),
//                                   ],
//                                 ),
//                                 child: TextField(
//                                   controller: _distanceController,
//                                   keyboardType: TextInputType.number,
//                                   decoration: InputDecoration(
//                                     labelText: 'Length of row in meters',
//                                     labelStyle: TextStyle(color: Colors.black, fontSize: isSmallScreen ? 10 : 13),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(20),
//                                       borderSide: BorderSide.none,
//                                     ),
//                                     contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                                     fillColor: Colors.transparent,
//                                   ),
//                                   style: const TextStyle(color: Colors.black),
//                                 ),
//                               ),
//                             ),
//                             for (int row = 0; row < 10; row++)
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: List.generate(
//                                   10,
//                                       (col) => Padding(
//                                     padding: EdgeInsets.symmetric(horizontal: 0.005 * screenWidth),
//                                     child: Container(
//                                       width: isSmallScreen ? 15 : 20,
//                                       height: isSmallScreen ? 15 : 20,
//                                       decoration: BoxDecoration(
//                                         color: ((col ~/ 2) % 2 == 0) ? Colors.green[700] : Colors.brown[400],
//                                         shape: BoxShape.circle,
//                                         boxShadow: [
//                                           const BoxShadow(
//                                             color: Colors.black38,
//                                             blurRadius: 4,
//                                             offset: Offset(2, 2),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Control Part
//                 Expanded(
//                   flex: 1,
//                   child: Column(
//                     children: [
//                       SizedBox(height: 0.148 * screenHeight),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           _buildButton(screenWidth, "Smart Drive", _toggleAutopilot),
//                           _buildButton(screenWidth, "Stop", _stopMoving),
//                         ],
//                       ),
//                       SizedBox(height: 0.05 * screenHeight),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           _buildControlButton(Icons.keyboard_arrow_up_sharp, "/go"),
//                         ],
//                       ),
//                       SizedBox(height: 0.02 * screenHeight),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           _buildControlButton(Icons.arrow_back_ios_new, "/left"),
//                           SizedBox(width: 0.04
//                               * screenWidth),
//                           // _buildCenterIcon(),
//                           // SizedBox(width: 0.015 * screenWidth),
//                           _buildControlButton(Icons.arrow_forward_ios, "/right"),
//                         ],
//                       ),
//                       SizedBox(height: 0.02 * screenHeight),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           _buildControlButton(Icons.keyboard_arrow_down, "/back"),
//                         ],
//                       ),
//                       SizedBox(height: 0.05 * screenHeight),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//
//   }
//
//   Widget _buildControlButton(IconData icon, String command) {
//     return GestureDetector(
//       onTapDown: (_) => _sendCommand(command),
//       onTapUp: (_) => _stopCommand(),
//       child: Container(
//         decoration: const BoxDecoration(
//           color: Color(0xFF7F7F7F),
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 6),
//           ],
//         ),
//         padding: const EdgeInsets.all(20),
//         child: Icon(icon, color: Colors.white),
//       ),
//     );
//   }
// }