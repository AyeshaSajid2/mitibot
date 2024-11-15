import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mitti_bot/src/Screens/home.dart';
import '../router_helper.dart';


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
      duration: Duration(seconds: 5), // Adjust duration as needed
    );

    // Create staggered animations for the logo and tagline
    _logoAnimation = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.5), // Logo animation from 0% to 50% of total duration
    );

    _taglineAnimation = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.3, 1.0), // Tagline animation from 50% to 100% of total duration
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // When the animation completes, navigate to the next screen
        // Routes.pushReplacementNamed(Routes.home);
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              // Define the scale transition
              final scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
              );

              // Define the slide transition
              final slideAnimation = Tween<Offset>(
                begin: Offset(1.0, 0.5), // Slide in from the bottom right
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              );

              // Define the fade transition
              final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeIn),
              );

              return FadeTransition(
                opacity: fadeAnimation,
                child: ScaleTransition(
                  scale: scaleAnimation,
                  child: SlideTransition(
                    position: slideAnimation,
                    child: child,
                  ),
                ),
              );
            },
            transitionDuration: Duration(seconds: 4), // Adjusted for a faster transition
          ),
        );


      }
    });

    // Start the animation
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
            mainAxisSize: MainAxisSize.min, // Adjusts column to fit its children
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
