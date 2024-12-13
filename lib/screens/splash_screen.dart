import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer; // Declare a Timer variable

  @override
  void initState() {
    super.initState();
    // Start a timer to navigate after a delay
    _timer = Timer(const Duration(seconds: 3), _navigateToHome);
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer if the widget is disposed
    super.dispose();
  }

  void _navigateToHome() {
    if (mounted) { // Check if the widget is still mounted
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background for a modern look
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Center the app name
          Expanded(
            child: Center(
              child: Text(
                'VidoMart',
                style: TextStyle(
                  fontSize: 48, // Reduced font size for a sleeker look
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 1.5, // Adjusted letter spacing
                ),
              ),
            ),
          ),
          // Position the tagline at the bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 20), // Adjusted padding
            child: Text(
              'from Zixno',
              textAlign: TextAlign.center, // Center the tagline
              style: TextStyle(
                fontSize: 18, // Reduced font size for a more elegant appearance
                fontWeight: FontWeight.w300,
                color: Colors.black54, // Slightly lighter color for the tagline
                letterSpacing: 1.2, // Adjusted letter spacing
              ),
            ),
          ),
        ],
      ),
    );
  }
}