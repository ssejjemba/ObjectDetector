import 'package:cats_and_dogs/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterSplashScreen(
        useImmersiveMode: true,
        duration: const Duration(milliseconds: 2000),
        nextScreen: const MyHomePage(),
        backgroundColor: const Color(0xFF282828),
        splashScreenBody: Center(
          child: Lottie.asset(
            "assets/animations/animation_starter.json",
            repeat: false,
          ),
        ),
      ),
    );
  }
}
