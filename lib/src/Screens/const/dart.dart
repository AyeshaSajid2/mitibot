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
