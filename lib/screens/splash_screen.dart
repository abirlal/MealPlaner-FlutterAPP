import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a delay for the splash screen
    Timer(Duration(seconds: 4), () {
      // Navigate to the next page after the splash screen
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color
      body: Center(
        child: Image.asset(
          'assets/images/logo.png', // Path to your logo image
          width: 150, // Adjust size as needed
          height: 150, // Adjust size as needed
          fit: BoxFit.cover, // Ensure the image fits well
        ),
      ),
    );
  }
}
