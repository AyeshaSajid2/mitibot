// // import 'dart:async';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// //
// // class FormPage extends StatefulWidget {
// //   final String ipAddress;
// //
// //   const FormPage({super.key, required this.ipAddress});
// //
// //   @override
// //   _FormPageState createState() => _FormPageState();
// // }
// //
// // class _FormPageState extends State<FormPage> {
// //   final TextEditingController _forwardDistanceController = TextEditingController();
// //   final TextEditingController _turnWidthController = TextEditingController();
// //   final TextEditingController _numberOfRowsController = TextEditingController();
// //
// //   bool isMoving = false;
// //   double remainingDistance = 0.0;
// //   double totalDistanceInMeters = 0.0;
// //   double distanceCovered = 0.0;
// //   Timer? _moveTimer;
// //
// //   int totalRows = 0;
// //   String firstTurn = 'left';
// //   double turnWidth = 0.0;
// //   bool shouldTurnLeft = true;
// //
// //   Future<void> _sendCommand(String command) async {
// //     try {
// //       final response = await http.get(Uri.parse('http://${widget.ipAddress}$command'));
// //       if (response.statusCode == 200) {
// //         print('Command sent successfully: $command');
// //       } else {
// //         print('Failed to send command: $command');
// //       }
// //     } catch (error) {
// //       print('Error sending command: $command, $error');
// //     }
// //   }
// //
// //   void _stopCommand() {
// //     _sendCommand('/stop');
// //   }
// //
// //   void _startAutomation() {
// //     totalDistanceInMeters = double.tryParse(_forwardDistanceController.text) ?? 0.0;
// //     remainingDistance = totalDistanceInMeters * 100;
// //     distanceCovered = 0.0;
// //
// //     totalRows = int.tryParse(_numberOfRowsController.text) ?? 0;
// //     turnWidth = double.tryParse(_turnWidthController.text) ?? 0.0;
// //
// //     if (remainingDistance > 0 && totalRows > 0) {
// //       setState(() {
// //         isMoving = true;
// //       });
// //       snackBarOverlay("Automation started", context);
// //       shouldTurnLeft = (firstTurn == 'left');
// //       _moveForward();
// //     }
// //   }
// //
// //   void _moveForward() {
// //     if (remainingDistance <= 0) {
// //       _stopMoving();
// //       return;
// //     }
// //
// //     _sendCommand('/forward');
// //     remainingDistance -= 5;
// //     distanceCovered += 5;
// //
// //     if (distanceCovered % 100 == 0) {
// //       snackBarOverlay("${(distanceCovered / 100).floor()} meter covered.", context);
// //     }
// //
// //     _moveTimer = Timer(const Duration(seconds: 1), () {
// //       _moveForward();
// //     });
// //
// //     if (distanceCovered >= totalDistanceInMeters * 100) {
// //       distanceCovered = 0;
// //       if (totalRows > 0) {
// //         _makeTurn();
// //       } else {
// //         _stopMoving();
// //       }
// //     }
// //   }
// //
// //   void _makeTurn() async {
// //     if (totalRows <= 0) {
// //       _stopMoving();
// //       return;
// //     }
// //
// //     // Determine the turn direction
// //     if (shouldTurnLeft) {
// //       await turnLeft(turnWidth);
// //     } else {
// //       await turnRight(turnWidth);
// //     }
// //
// //     shouldTurnLeft = !shouldTurnLeft; // Alternate turn direction
// //     totalRows--; // Decrement the row count
// //     remainingDistance = totalDistanceInMeters * 100; // Reset forward distance for next row
// //     _moveForward();
// //   }
// //
// //   Future<void> turnLeft(double width) async {
// //     await _sendCommand('/left');
// //     await Future.delayed(const Duration(seconds: 1));
// //
// //     for (int i = 0; i < width ~/ 5; i++) {
// //       await _sendCommand('/forward');
// //     }
// //
// //     await _sendCommand('/left');
// //     await Future.delayed(const Duration(seconds: 1));
// //     _stopCommand();
// //   }
// //
// //   Future<void> turnRight(double width) async {
// //     await _sendCommand('/right');
// //     await Future.delayed(const Duration(seconds: 1));
// //
// //     for (int i = 0; i < width ~/ 5; i++) {
// //       await _sendCommand('/forward');
// //     }
// //
// //     await _sendCommand('/right');
// //     await Future.delayed(const Duration(seconds: 1));
// //     _stopCommand();
// //   }
// //
// //   void _stopMoving() {
// //     _moveTimer?.cancel();
// //     setState(() {
// //       isMoving = false;
// //     });
// //     _stopCommand();
// //     snackBarOverlay("Automation stopped", context);
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Automation Form'),
// //         backgroundColor: Colors.green,
// //       ),
// //       body: SingleChildScrollView(
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Column(
// //             children: [
// //               TextField(
// //                 controller: _forwardDistanceController,
// //                 keyboardType: TextInputType.number,
// //                 decoration: const InputDecoration(
// //                   labelText: 'Enter forward distance in meters',
// //                   border: OutlineInputBorder(),
// //                 ),
// //               ),
// //               const SizedBox(height: 10),
// //               TextField(
// //                 controller: _turnWidthController,
// //                 keyboardType: TextInputType.number,
// //                 decoration: const InputDecoration(
// //                   labelText: 'Enter turn width in cm',
// //                   border: OutlineInputBorder(),
// //                 ),
// //               ),
// //               const SizedBox(height: 10),
// //               TextField(
// //                 controller: _numberOfRowsController,
// //                 keyboardType: TextInputType.number,
// //                 decoration: const InputDecoration(
// //                   labelText: 'Enter number of rows',
// //                   border: OutlineInputBorder(),
// //                 ),
// //               ),
// //               const SizedBox(height: 10),
// //               DropdownButtonFormField<String>(
// //                 value: firstTurn,
// //                 items: ['left', 'right']
// //                     .map((turn) => DropdownMenuItem(value: turn, child: Text(turn)))
// //                     .toList(),
// //                 onChanged: (value) {
// //                   setState(() {
// //                     firstTurn = value ?? 'left';
// //                   });
// //                 },
// //                 decoration: const InputDecoration(
// //                   labelText: 'Choose first turn',
// //                   border: OutlineInputBorder(),
// //                 ),
// //               ),
// //               const SizedBox(height: 20),
// //               ElevatedButton(
// //                 onPressed: isMoving ? null : _startAutomation,
// //                 child: Text(isMoving ? 'Running...' : 'Start Automation'),
// //               ),
// //               const SizedBox(height: 20),
// //               ElevatedButton(
// //                 onPressed: _stopMoving,
// //                 child: const Text('Stop Automation'),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // void snackBarOverlay(String message, BuildContext context) {
// //   ScaffoldMessenger.of(context).showSnackBar(
// //     SnackBar(
// //       content: Text(message),
// //       backgroundColor: Colors.green,
// //     ),
// //   );
// // }
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:mitti_bot/src/widgets/path_representation.dart';
//  // Import the graphical representation file
//
// class FormPage extends StatefulWidget {
//   final String ipAddress;
//
//   const FormPage({super.key, required this.ipAddress});
//
//   @override
//   _FormPageState createState() => _FormPageState();
// }
//
// class _FormPageState extends State<FormPage> {
//   final TextEditingController _forwardDistanceController = TextEditingController();
//   final TextEditingController _turnWidthController = TextEditingController();
//   final TextEditingController _numberOfRowsController = TextEditingController();
//
//   bool isMoving = false;
//   double remainingDistance = 0.0;
//   double totalDistanceInMeters = 0.0;
//   double distanceCovered = 0.0;
//   Timer? _moveTimer;
//
//   int totalRows = 0;
//   String firstTurn = 'left';
//   double turnWidth = 0.0;
//   bool shouldTurnLeft = true;
//
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
//   void _stopCommand() {
//     _sendCommand('/stop');
//   }
//
//   void _startAutomation() {
//     totalDistanceInMeters = double.tryParse(_forwardDistanceController.text) ?? 0.0;
//     remainingDistance = totalDistanceInMeters * 100;
//     distanceCovered = 0.0;
//
//     totalRows = int.tryParse(_numberOfRowsController.text) ?? 0;
//     turnWidth = double.tryParse(_turnWidthController.text) ?? 0.0;
//
//     if (remainingDistance > 0 && totalRows > 0) {
//       setState(() {
//         isMoving = true;
//       });
//       snackBarOverlay("Automation started", context);
//       shouldTurnLeft = (firstTurn == 'left');
//       _moveForward();
//     }
//   }
//
//   void _moveForward() {
//     if (remainingDistance <= 0) {
//       _stopMoving();
//       return;
//     }
//
//     _sendCommand('/forward');
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
//
//     if (distanceCovered >= totalDistanceInMeters * 100) {
//       distanceCovered = 0;
//       if (totalRows > 0) {
//         _makeTurn();
//       } else {
//         _stopMoving();
//       }
//     }
//   }
//
//   void _makeTurn() async {
//     if (totalRows <= 0) {
//       _stopMoving();
//       return;
//     }
//
//     // Determine the turn direction
//     if (shouldTurnLeft) {
//       await turnLeft(turnWidth);
//     } else {
//       await turnRight(turnWidth);
//     }
//
//     shouldTurnLeft = !shouldTurnLeft; // Alternate turn direction
//     totalRows--; // Decrement the row count
//     remainingDistance = totalDistanceInMeters * 100; // Reset forward distance for next row
//     _moveForward();
//   }
//
//   Future<void> turnLeft(double width) async {
//     await _sendCommand('/left');
//     await Future.delayed(const Duration(seconds: 1));
//
//     for (int i = 0; i < width ~/ 5; i++) {
//       await _sendCommand('/forward');
//     }
//
//     await _sendCommand('/left');
//     await Future.delayed(const Duration(seconds: 1));
//     _stopCommand();
//   }
//
//   Future<void> turnRight(double width) async {
//     await _sendCommand('/right');
//     await Future.delayed(const Duration(seconds: 1));
//
//     for (int i = 0; i < width ~/ 5; i++) {
//       await _sendCommand('/forward');
//     }
//
//     await _sendCommand('/right');
//     await Future.delayed(const Duration(seconds: 1));
//     _stopCommand();
//   }
//
//   void _stopMoving() {
//     _moveTimer?.cancel();
//     setState(() {
//       isMoving = false;
//     });
//     _stopCommand();
//     snackBarOverlay("Automation stopped", context);
//   }
//
//   void _navigateToGraphicalRepresentation() {
//     final double forwardDistance = double.tryParse(_forwardDistanceController.text) ?? 0.0;
//     final double turnWidth = double.tryParse(_turnWidthController.text) ?? 0.0;
//     final int numberOfRows = int.tryParse(_numberOfRowsController.text) ?? 0;
//
//     if (forwardDistance > 0 && turnWidth > 0 && numberOfRows > 0) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => GraphicalRepresentation(
//             forwardDistance: forwardDistance,
//             turnWidth: turnWidth,
//             numberOfRows: numberOfRows,
//             firstTurn: firstTurn,
//           ),
//         ),
//       );
//     } else {
//       snackBarOverlay("Please enter valid values", context);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Automation Form'),
//         backgroundColor: Colors.green,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               TextField(
//                 controller: _forwardDistanceController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   labelText: 'Enter forward distance in meters',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: _turnWidthController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   labelText: 'Enter turn width in cm',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: _numberOfRowsController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   labelText: 'Enter number of rows',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               DropdownButtonFormField<String>(
//                 value: firstTurn,
//                 items: ['left', 'right']
//                     .map((turn) => DropdownMenuItem(value: turn, child: Text(turn)))
//                     .toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     firstTurn = value ?? 'left';
//                   });
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Choose first turn',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: isMoving ? null : _startAutomation,
//                 child: Text(isMoving ? 'Running...' : 'Start Automation'),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _stopMoving,
//                 child: const Text('Stop Automation'),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _navigateToGraphicalRepresentation,
//                 child: const Text('View Graphical Representation'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// void snackBarOverlay(String message, BuildContext context) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(message),
//       backgroundColor: Colors.green,
//     ),
//   );
// }
