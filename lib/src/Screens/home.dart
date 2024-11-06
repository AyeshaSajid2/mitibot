import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cam_view.dart';

class HomePage extends StatefulWidget {
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
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Positioned IP Input and Button to the right and lower
            Align(
              alignment: Alignment(0.9, 1.0), // Adjust alignment to the right and lower
              child: Padding(
                padding: const EdgeInsets.only(right: 25.0, bottom: 20.0, left: 350), // Add any desired padding
                child: GameIdInput(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameIdInput extends StatefulWidget {
  @override
  _GameIdInputState createState() => _GameIdInputState();
}

class _GameIdInputState extends State<GameIdInput> {
  TextEditingController _urlController = TextEditingController();
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
          width: 320,
          height: 55,// Reduced width for the IP input field
          decoration: BoxDecoration(
            gradient: LinearGradient(
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
                offset: Offset(4, 4),
                blurRadius: 4,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                offset: Offset(-4, -4),
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
                MaterialPageRoute(
                  builder: (context) => MonitoringPage(
                    ipAddress: _urlController.text,
                  ),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            // shadowColor: Colors.grey,
            shadowColor: Colors.black,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            padding: EdgeInsets.zero, // Reset outer padding for consistent button size
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Increased internal padding for text
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF7F7F7F),
                  Color(0xFF7F7F7F)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
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
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: const Text(
              'Drive',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
