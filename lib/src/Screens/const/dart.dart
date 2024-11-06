// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:http/http.dart' as http;
// import '../../widgets/distance_calculate.dart';
// import '../../widgets/snackbar.dart';
//
// class MonitoringPage extends StatefulWidget {
//   final String ipAddress;
//
//   const MonitoringPage({super.key, required this.ipAddress});
//   @override
//   _MonitoringPageState createState() => _MonitoringPageState();
// }
//
// class _MonitoringPageState extends State<MonitoringPage> {
//   final DistanceCalculator distanceCalculator = DistanceCalculator();
//   double distanceCovered = 0.0; // Distance covered example value
//   double totalDistanceInMeters = 0.0; // Total distance example value
//   int remainingTime = 120; // Example remaining time in seconds
//   bool isAutoPilotEnabled = false;
//   bool isMoving = false;
//   double remainingDistance = 0.0;
//   Timer? _moveTimer;
//   String displayTime = '';
//
//   void _toggleAutopilot() {
//     setState(() {
//       isAutoPilotEnabled = !isAutoPilotEnabled;
//     });
//     if (isMoving) {
//       _stopMoving(); // If moving, stop it
//     } else {
//       _startMoving(); // If not moving, start it
//     }
//   }
//
//   void _startMoving() {
//     if (remainingDistance <= 0) {
//       _stopMoving(); // Stop if no distance remaining
//       return;
//     }
//
//     _sendCommand('/forward');
//     remainingDistance -= 5; // Move forward by 5 cm
//     distanceCovered += 5; // Update distance covered
//
//     // Check if a meter has been covered
//     if (distanceCovered % 100 == 0) {
//       snackBarOverlay("${(distanceCovered / 100).floor()} meter covered.", context);
//     }
//
//     // Move for 1 second for every 5 cm
//     _moveTimer = Timer(const Duration(seconds: 1), () {
//       // After 1 second, check remaining distance
//       _startMoving();
//     });
//   }
//
//   void _stopMoving() {
//     _moveTimer?.cancel(); // Cancel the timer
//     isMoving = false;
//     _sendCommand('/stop');
//     snackBarOverlay("Automation deactivated", context);
//   }
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
//   void _calculateTime() {
//     setState(() {
//       displayTime = distanceCalculator.getTimeNeeded();
//       // Optionally clear the input after displaying the time
//       // distanceCalculator.clearInput(); // Uncomment if you want to clear input
//     });
//   }
//
//   void _stopCommand({String stopCommand = '/stop'}) {
//     _sendCommand(stopCommand);
//   }
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
//           SizedBox(height: 4),
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
//   Widget _buildActionButton(String label, VoidCallback onPressed) {
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
//         padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//         child: Text(label, style: TextStyle(color: Colors.black)),
//       ),
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: Color(0xFFCECECE),
//       body: Padding(
//         padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 60.0,right: 20.0),
//         child: Row(
//           children: [
//             // Left container
//             Container(
//               width: width * 0.32, // Use 32% of screen width
//               height: height, // Full height of the screen
//               decoration: BoxDecoration(
//                 color: Color(0xFFececec), // Background color
//                 borderRadius: BorderRadius.circular(16), // Circular corners
//               ),
//              child:  Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
//                       height: height * 0.6, // 70% of the outer container height
//                       width: double.infinity, // Full width of the parent
//                       decoration: BoxDecoration(
//                         color: Color(0xFF272727), // Inner box color
//                         borderRadius: BorderRadius.circular(16), // Circular corners
//                       ),
//                       child: Column(
//                         children: [
//                           Container(
//                             height: height * 0.3, // 30% of the height of the black container (0.3 * 0.7)
//                             width: double.infinity, // Full width of the black container
//                             decoration: BoxDecoration(
//                               color: Color(0xFFABC8D6), // Inner inner box color
//                               borderRadius: BorderRadius.circular(16), // Circular corners
//                             ),
//                             child: Center(
//                               child: Text(
//                                 displayTime.isNotEmpty ? displayTime : 'Time',
//                                 style: TextStyle(fontSize: 24), // Display time or prormpt
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 10),
//                           Container(
//                             decoration: BoxDecoration(
//                               color: Colors.black, // Background color of the TextField
//                               borderRadius: BorderRadius.circular(12.0), // Rounded corners
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey.withOpacity(0.5), // Shadow color
//                                   offset: Offset(4, 4), // Offset of the shadow
//                                   blurRadius: 8.0, // Blur radius of the shadow
//                                   spreadRadius: 2.0, // Spread radius of the shadow
//                                 ),
//                               ],
//                             ),
//                             child: TextField(
//                               controller: distanceCalculator.distanceController,
//                               keyboardType: TextInputType.number,
//                               style: TextStyle(color: Color(0xFFABC8D6)), // Text color
//                               decoration: InputDecoration(
//                                 filled: true, // Fill the background
//                                 fillColor: Colors.transparent, // Keep fillColor transparent
//                                 labelText: 'Enter distance in meters',
//                                 labelStyle: TextStyle(color: Colors.blue), // Label color
//                                 border: InputBorder.none, // Remove default border
//                                 contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0), // Reduced padding inside the TextField
//                                 floatingLabelBehavior: FloatingLabelBehavior.auto, // Floating label behavior
//                               ),
//                             ),
//                           ),
//
//
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 14), // Optional space between the black container and the bottom (if needed)
//                   ],
//                 ),
//               ),
//             ),
//
//
//             SizedBox(width: 16), // Space between left and right containers
//
//             // Right side with two stacked containers
//             Expanded(
//               child: Column(
//                 children: [
//                   // Top-right container
//                   Container(
//                     height: height * 0.22,
//                     child: Stack(
//                       children: [
//                         // Long horizontal line
//                         Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Container(
//                             height: 5, // Height of the horizontal line
//                             decoration: BoxDecoration(
//                               color: Colors.black,
//                               borderRadius: BorderRadius.circular(2.5), // Rounded edges for a smooth look
//                             ),
//                           ),
//                         ),
//                         // Time intervals and vertical markers
//                         SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             children: distanceCalculator.getTimeIntervals().asMap().entries.map((entry) {
//                               int index = entry.key;
//                               String interval = entry.value;
//
//                               return Container(
//                                 padding: EdgeInsets.symmetric(horizontal: 8.0),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     // Vertical bars
//                                     if (index > 0) ...[
//                                       // Small vertical bar between intervals
//                                       Container(
//                                         width: 2,
//                                         height: 15, // Small vertical bar height
//                                         color: Colors.white,
//                                       ),
//                                       SizedBox(height: 5),
//                                     ],
//                                     Text(
//                                       interval,
//                                       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                         // Red vertical indicator
//                         Positioned(
//                           left: 60, // Adjust position based on index
//                           top: 0,
//                           child: Container(
//                             width: 4,
//                             height: 30, // Height of the red indicator
//                             color: Colors.red,
//
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//
//
//                   SizedBox(height: 16), // Space between top and bottom containers
//
//                   // Bottom-right container
//                   Expanded(
//                     child: Container(
//                       child: _buildControlPanel(),
//                       height: height * 0.33,
//                       color: Colors.red,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
///TODO: Home Page
///import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:just_audio/just_audio.dart';
// import 'cam_view.dart';
// import 'const/dart.dart';
//
// class HomePage extends StatefulWidget {
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
//   late AudioPlayer _audioPlayer;
//   bool _canExit = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _audioPlayer = AudioPlayer();
//     _playAudio();
//     WidgetsBinding.instance.addObserver(this);
//   }
//
//   Future<void> _playAudio() async {
//     String audioPath = "assets/sound.mp3";
//     await _audioPlayer.setAsset(audioPath);
//     _audioPlayer.setLoopMode(LoopMode.one); // Set loop mode
//     _audioPlayer.play();
//   }
//
//   @override
//   void dispose() {
//     _audioPlayer.dispose(); // Stop audio on dispose
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused) {
//       _audioPlayer.pause();
//     } else if (state == AppLifecycleState.resumed) {
//       _audioPlayer.play();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (_canExit) {
//           return true;
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Press again to exit'),
//               duration: Duration(seconds: 2),
//             ),
//           );
//           _canExit = true;
//           Future.delayed(const Duration(seconds: 2), () {
//             _canExit = false;
//           });
//           return false;
//         }
//       },
//       child: SafeArea(
//         child: Scaffold(
//           resizeToAvoidBottomInset: true,
//           body: Stack(
//             children: [
//               // Full-screen background image using Container
//
//               Positioned.fill(
//                 top: -MediaQuery.of(context).size.height * 0.6,
//                 child: Container(
//                   decoration: const BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage('assets/images/background.png'), // Replace with your image path
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // First half
//                   Expanded(
//                     flex: 1,
//                     child: LayoutBuilder(
//                       builder: (context, constraints) {
//                         return Stack(
//                           children: [
//                             // Use Positioned.fill to ensure background image fills the container
//
//                             // Positioned.fill(
//                             //   top: -MediaQuery.of(context).size.height * 0.6,
//                             //   child: SizedBox(
//                             //     height: constraints.maxHeight * 0.79,
//                             //     width: constraints.maxWidth,
//                             //     child: Image.asset(
//                             //       'assets/images/bg_left.png',
//                             //       fit: BoxFit.cover,
//                             //     ),
//                             //   ),
//                             // ),
//                             // // Middle image positioned
//                             Positioned(
//                               top: constraints.maxHeight * 0.15,
//                               left: -31,
//                               child: SizedBox(
//                                 height: constraints.maxHeight * 0.83,
//                                 width: constraints.maxWidth,
//                                 child: Image.asset(
//                                   'assets/images/Best Gamer Gear (6).png',
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                             // Bottom image positioned
//                             Positioned(
//                               right: -43,
//                               bottom: -32,
//                               child: SizedBox(
//                                 width: constraints.maxWidth * 0.6,
//                                 height: constraints.maxHeight * 0.68,
//                                 child: Image.asset(
//                                   'assets/images/gardro_device.png',
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//
//                   // Second half
//                   Expanded(
//                     flex: 1,
//                     child: LayoutBuilder(
//                       builder: (context, constraints) {
//                         return Stack(
//                           children: [  // Positioned.fill(
//                             //   top: -MediaQuery.of(context).size.height * 0.6,
//                             //   child: Image.asset(
//                             //     'assets/images/bg_r.png',
//                             //     fit: BoxFit.cover,
//                             //   ),
//                             // ),
//
//                             // Column containing the text image and GameIdInput
//                             Positioned.fill(
//                               child: SingleChildScrollView(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         Container(
//                                           width: constraints.maxWidth,
//                                           height: constraints.maxWidth * 0.45,
//                                           child: Image.asset(
//                                             "assets/images/gardro_text.png",
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.all(constraints.maxHeight * 0.00001),
//                                       child: GameIdInput(),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class GameIdInput extends StatefulWidget {
//   @override
//   _GameIdInputState createState() => _GameIdInputState();
// }
//
// class _GameIdInputState extends State<GameIdInput> {
//   TextEditingController _urlController = TextEditingController();
//   late SharedPreferences _prefs;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadLastEnteredText();
//   }
//
//   void _loadLastEnteredText() async {
//     _prefs = await SharedPreferences.getInstance();
//     String? lastText = _prefs.getString('lastEnteredText');
//     if (lastText != null) {
//       setState(() {
//         _urlController.text = lastText;
//       });
//     }
//   }
//
//   void _saveLastEnteredText(String text) {
//     _prefs.setString('lastEnteredText', text);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           TextField(
//             controller: _urlController,
//             onChanged: (text) {
//               _saveLastEnteredText(text);
//             },
//             keyboardType: TextInputType.url,
//             decoration: InputDecoration(
//               labelText: 'Enter IP Address',
//               hintText: 'eg: 193.38.18',
//               filled: true,
//               labelStyle: const TextStyle(
//                 color: Colors.blue,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'VarelaRound',
//               ),
//               helperStyle: const TextStyle(
//                 color: Color.fromRGBO(200, 198, 188, 1),
//               ),
//               hintStyle: const TextStyle(
//                 color: Color.fromRGBO(200, 198, 188, 1),
//               ),
//               fillColor: Colors.grey[900],
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(25.0),
//                 borderSide: BorderSide.none,
//               ),
//               prefixIcon: const Icon(
//                 Icons.videogame_asset,
//                 color: Color.fromRGBO(200, 198, 188, 1),
//               ),
//               suffixIcon: IconButton(
//                 icon: const Icon(
//                   Icons.clear,
//                   color: Color.fromRGBO(200, 198, 188, 1),
//                 ),
//                 onPressed: () {
//                   _urlController.clear();
//                 },
//               ),
//               errorBorder: OutlineInputBorder(
//                 borderSide: const BorderSide(color: Colors.red),
//                 borderRadius: BorderRadius.circular(25.0),
//               ),
//               focusedErrorBorder: OutlineInputBorder(
//                 borderSide: const BorderSide(color: Colors.red),
//                 borderRadius: BorderRadius.circular(25.0),
//               ),
//             ),
//             style: const TextStyle(
//               color: Color.fromRGBO(200, 198, 188, 1),
//             ),
//           ),
//           SizedBox(
//             height: MediaQuery.of(context).size.height * .04266,
//           ),
//           Center(
//             child: ElevatedButton(
//               onPressed: () {
//                 if (_urlController.text != "") {
//                   Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(
//                       builder: (context) => MonitoringPage(
//                         ipAddress: _urlController.text,
//                       ), // Replace with your home screen widget
//                     ),
//                   );
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: const Color.fromRGBO(200, 198, 188, 1), backgroundColor: Colors.grey[900],
//                 elevation: 5,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20.0),
//                 ),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.all(
//                   MediaQuery.of(context).size.height * .0175,
//                 ),
//                 child: const Text(
//                   'Explore',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w500,
//                     fontFamily: 'VarelaRound',
//                   ),
//                 ),
//               ),
//             ),
//           )
//
//         ],
//       ),
//     );
//   }
// }