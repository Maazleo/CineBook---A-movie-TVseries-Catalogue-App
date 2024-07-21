import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, // Ensure it takes full width
        height: double.infinity, // Ensure it takes full height
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/images/splash.png"), // Ensure the path is correct
            fit: BoxFit.cover, // Cover the entire screen area
          ),
        ),
      ),
    );
  }
}
