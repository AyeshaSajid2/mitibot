import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _taglineAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _logoAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5),
    );

    _taglineAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );

      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _logoAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _logoAnimation.value,
                    child: Image.asset(
                      'assets/onboarding_images/freeman.jpg',
                      width: MediaQuery.of(context).size.width * 0.3,
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: _taglineAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _taglineAnimation.value,
                    child: Image.asset(
                      'assets/onboarding_images/tribe.jpg',
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
