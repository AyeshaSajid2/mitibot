// import 'package:flutter/material.dart';
//
// class MonitoringPage extends StatefulWidget {
//   @override
//   _MonitoringPageState createState() => _MonitoringPageState();
// }
//
// class _MonitoringPageState extends State<MonitoringPage> {
//   double distanceCovered = 50.0; // Distance covered example value
//   double totalDistanceInMeters = 100.0; // Total distance example value
//   int remainingTime = 120; // Example remaining time in seconds
//   bool isAutoPilotEnabled = false;
//
//   void _toggleAutopilot() {
//     setState(() {
//       isAutoPilotEnabled = !isAutoPilotEnabled;
//     });
//     // Add actual autopilot control logic here
//   }
//
//   void _stopMoving() {
//     // Add stop command logic here
//   }
//
//   void _sendCommand(String command) {
//     // Add command send logic here
//     print("Command sent: $command");
//   }
//
//   void _stopCommand({String stopCommand = ''}) {
//     // Add command stop logic here
//     print("Stop command sent: $stopCommand");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[300], // Background to match the image
//       body: Stack(
//         children: <Widget>[
//           // Back Button
//           Positioned(
//             top: 20,
//             left: 20,
//             child: GestureDetector(
//               onTap: () => Navigator.of(context).pop(),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.black,
//                   shape: BoxShape.circle,
//                 ),
//                 padding: EdgeInsets.all(16),
//                 child: Icon(
//                   Icons.arrow_back,
//                   color: Colors.white,
//                   size: 32.0,
//                 ),
//               ),
//             ),
//           ),
//           // Distance Covered Bar
//           Positioned(
//             top: 80,
//             left: 20,
//             right: 20,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Distance Covered',
//                   style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8),
//                 Stack(
//                   children: [
//                     Container(
//                       height: 10,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[400],
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     FractionallySizedBox(
//                       widthFactor: distanceCovered / totalDistanceInMeters,
//                       child: Container(
//                         height: 10,
//                         decoration: BoxDecoration(
//                           color: Colors.green,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 5),
//                 Text(
//                   '${distanceCovered.toStringAsFixed(1)} meters',
//                   style: TextStyle(color: Colors.black54, fontSize: 14),
//                 ),
//               ],
//             ),
//           ),
//           // Remaining Time
//           Positioned(
//             top: 150,
//             left: 20,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Remaining Time',
//                   style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   '${remainingTime.toString()} seconds',
//                   style: TextStyle(color: Colors.black54, fontSize: 14),
//                 ),
//                 SizedBox(height: 8),
//                 // Additional info placeholder
//                 Text('Additional Info', style: TextStyle(color: Colors.black54)),
//               ],
//             ),
//           ),
//           // Controls with Weed Button
//           Positioned(
//             top: MediaQuery.of(context).size.height / 2 - 50,
//             left: MediaQuery.of(context).size.width / 2 - 50,
//             child: Column(
//               children: [
//                 _buildControlPanel(), // Control buttons with styling
//                 SizedBox(height: 20),
//                 _buildWeedButton(), // Central Weed Button
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Control Panel with 3D buttons and AutoPilot feature
//   Widget _buildControlPanel() {
//     return Container(
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(color: Colors.grey[500]!, offset: Offset(4, 4), blurRadius: 10),
//           BoxShadow(color: Colors.white, offset: Offset(-4, -4), blurRadius: 10),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [_buildDirectionButton(Icons.arrow_upward, '/go')],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _buildDirectionButton(Icons.arrow_back, '/left'),
//               SizedBox(width: 40),
//               _buildDirectionButton(Icons.arrow_forward, '/right'),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [_buildDirectionButton(Icons.arrow_downward, '/back')],
//           ),
//           SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _buildActionButton('AutoPilot', _toggleAutopilot),
//               SizedBox(width: 20),
//               _buildActionButton('Stop', _stopMoving),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   // 3D Direction Button
//   Widget _buildDirectionButton(IconData icon, String command) {
//     return GestureDetector(
//       onTapDown: (_) => _sendCommand(command),
//       onTapUp: (_) => _stopCommand(),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [
//             BoxShadow(color: Colors.grey[500]!, offset: Offset(4, 4), blurRadius: 10),
//             BoxShadow(color: Colors.white, offset: Offset(-4, -4), blurRadius: 10),
//           ],
//         ),
//         padding: EdgeInsets.all(12),
//         child: Icon(icon, color: Colors.black),
//       ),
//     );
//   }
//
//   // 3D Weed Button
//   Widget _buildWeedButton() {
//     return GestureDetector(
//       onTapDown: (_) => _sendCommand('/ledon'),
//       onTapUp: (_) => _stopCommand(stopCommand: '/ledoff'),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(color: Colors.grey[500]!, offset: Offset(4, 4), blurRadius: 10),
//             BoxShadow(color: Colors.white, offset: Offset(-4, -4), blurRadius: 10),
//           ],
//         ),
//         padding: EdgeInsets.all(20),
//         child: Icon(Icons.electric_bolt_sharp, color: Colors.black),
//       ),
//     );
//   }
//
//   // Action Button for AutoPilot and Stop
//   Widget _buildActionButton(String label, Function() onPressed) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [
//             BoxShadow(color: Colors.grey[500]!, offset: Offset(4, 4), blurRadius: 10),
//             BoxShadow(color: Colors.white, offset: Offset(-4, -4), blurRadius: 10),
//           ],
//         ),
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         child: Text(label, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
//       ),
//     );
//   }
// }
