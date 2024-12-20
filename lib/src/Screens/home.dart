// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cam_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/onboarding_images/background.jpg'),
                    // fit: BoxFit.cover,
                    fit: BoxFit.contain, //Ensures the image covers the entire screen
                  ),
                ),
              ),
            ),
            // Positioned IP Input and Button to the right and lower
            Align(
              alignment: Alignment.bottomRight, // Adjust alignment to the bottom right
              child: Padding(
                padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.05, // Responsive right padding
                  bottom: MediaQuery.of(context).size.height * 0.05, // Responsive bottom padding
                ),
                child: const GameIdInput(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameIdInput extends StatefulWidget {
  const GameIdInput({super.key});

  @override
  _GameIdInputState createState() => _GameIdInputState();
}

class _GameIdInputState extends State<GameIdInput> {
  final TextEditingController _urlController = TextEditingController();
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadLastEnteredText();
  }

  void _loadLastEnteredText() async {
    _prefs = await SharedPreferences.getInstance();
    String? lastText = _prefs.getString('lastEnteredText');
    if (lastText != null) {
      setState(() {
        _urlController.text = lastText;
      });
    }
  }

  void _saveLastEnteredText(String text) {
    _prefs.setString('lastEnteredText', text);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return Column(
      mainAxisSize: MainAxisSize.min, // Adjust to wrap content only
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.46, // Makes width responsive
          height: MediaQuery.of(context).size.height * 0.16, // Responsive height
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF626262),
                Color(0xFF7F7F7F)
              ], // Gradient colors
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
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: TextField(
            controller: _urlController,
            onChanged: (text) {
              _saveLastEnteredText(text);
            },
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              labelText: 'Enter IP Address',
              hintText: 'eg: 193.38.18',
              filled: true,
              labelStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              hintStyle: const TextStyle(
                color: Colors.grey,
              ),
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(
                Icons.videogame_asset,
                color: Colors.grey,
              ),
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: Colors.grey,
                ),
                onPressed: () {
                  _urlController.clear();
                },
              ),
            ),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .008,
        ),
        ElevatedButton(
          onPressed: () {
            if (_urlController.text != "") {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => MonitoringPage(
                    ipAddress: _urlController.text,
                  ),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    // Scale transition
                    const begin = 0.0;
                    const end = 1.0;
                    const curve = Curves.easeInOut;

                    var tween = Tween<double>(begin: begin, end: end).chain(CurveTween(curve: curve));
                    var fadeTween = Tween<double>(begin: 0.0, end: 1.0);

                    return FadeTransition(
                      opacity: animation.drive(fadeTween),
                      child: ScaleTransition(
                        scale: animation.drive(tween),
                        child: child,
                      ),
                    );
                  },
                  transitionDuration: const Duration(seconds: 1), // Slows down the animation to 1.5 seconds
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            shadowColor: Colors.black,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            padding: EdgeInsets.zero, // Reset outer padding for consistent button size
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Increased internal padding for text
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF7F7F7F),
                  Colors.white
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
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: const Text(
              'Drive',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
