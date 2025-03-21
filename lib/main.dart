import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import HomeScreen

void main() {
  runApp(FunMasterApp());
}

class FunMasterApp extends StatelessWidget {
  const FunMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FunMaster',
      theme: ThemeData.dark(), // Dark Theme
      home: HomeScreen(), // Set HomeScreen as the main screen
    );
  }
}
