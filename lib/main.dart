import 'package:cats_and_dogs/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF282828),
        fontFamily: 'NotoSansKR',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white), // General body text style
          bodyMedium: TextStyle(color: Colors.white70), // Less emphasized text
          displayLarge:
              TextStyle(color: Colors.white), // Large text such as titles
        ),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

// #282828