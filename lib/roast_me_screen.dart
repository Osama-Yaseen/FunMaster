import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:share_plus/share_plus.dart'; // ✅ Import Share

import '../data/roasts.dart'; // ✅ Import roast messages

class RoastMeScreen extends StatefulWidget {
  const RoastMeScreen({super.key});

  @override
  State<RoastMeScreen> createState() => _RoastMeScreenState();
}

class _RoastMeScreenState extends State<RoastMeScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _buttonController;
  late Animation<double> _buttonScaleAnimation;
  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String _currentRoast = "Tap below to get roasted! 🔥";

  bool _isAppActive = true; // ✅ Track app state

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // ✅ Observe app lifecycle

    // 🔥 Button Animation
    _buttonController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      lowerBound: 0.95,
      upperBound: 1.0,
    )..repeat(reverse: true);

    _buttonScaleAnimation = _buttonController.drive(
      Tween<double>(
        begin: 0.95,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeInOut)),
    );

    // 🎙️ Configure Text-to-Speech (TTS)
    _flutterTts.setLanguage("en-US");
    _flutterTts.setPitch(1.0);
    _flutterTts.setSpeechRate(0.5);
  }

  // ✅ **Handle App Lifecycle Changes**
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _isAppActive = false;
      _flutterTts.stop(); // 🔇 Stop TTS when app is in background
      _audioPlayer.stop(); // 🔇 Stop laugh sound when app is inactive
    } else if (state == AppLifecycleState.resumed) {
      _isAppActive = true;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // ✅ Remove observer
    _buttonController.dispose();
    _flutterTts.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _generateRoast() async {
    setState(() {
      _currentRoast = roasts[Random().nextInt(roasts.length)];
    });

    // ✅ Ensure TTS waits for completion BEFORE speaking
    await _flutterTts.awaitSpeakCompletion(true);

    // 🎙️ Speak the roast out loud
    await _flutterTts.speak(_currentRoast);
    await _flutterTts.awaitSpeakCompletion(
      true,
    ); // ✅ This will fully wait before playing sound

    // 😂 Play laugh sound ONLY IF APP IS ACTIVE
    if (_isAppActive) {
      await Future.delayed(
        Duration(milliseconds: 300),
      ); // ✅ Small delay before playing laugh sound
      await _audioPlayer.play(AssetSource("laugh_funny.wav"));
    }
  }

  // ✅ Share Roast Function
  void _shareRoast() {
    Share.share(
      "🔥 Here's a roast for you! 😂\n\n'$_currentRoast'\n\nSent from FunMaster! 🔥",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade900, Colors.indigo.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔥 Lottie Animation
                Lottie.asset(
                  "assets/laughing.json",
                  height: 180,
                  width: 180,
                  repeat: true,
                ),

                SizedBox(height: 20),

                // 🔹 Glowing Roast Text Box
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.pinkAccent, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pinkAccent.withOpacity(0.8),
                        blurRadius: 15,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Text(
                    _currentRoast,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: Colors.pinkAccent, blurRadius: 15),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 🔥 Generate Roast Button
                    ScaleTransition(
                      scale: _buttonScaleAnimation,
                      child: GestureDetector(
                        onTap: _generateRoast,
                        child: Container(
                          width: 180,
                          padding: EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                              color: Colors.blueAccent,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueAccent.withOpacity(0.8),
                                blurRadius: 25,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "🔥 Next Roast",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                                shadows: [
                                  Shadow(
                                    color: Colors.blueAccent,
                                    blurRadius: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 20),

                    // 📤 **Share Button**
                    ScaleTransition(
                      scale: _buttonScaleAnimation,
                      child: GestureDetector(
                        onTap: _shareRoast,
                        child: Container(
                          width: 120,
                          padding: EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                              color: Colors.greenAccent,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.greenAccent.withOpacity(0.8),
                                blurRadius: 25,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.share,
                                  color: Colors.greenAccent,
                                  size: 22,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Share",
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.greenAccent,
                                    shadows: [
                                      Shadow(
                                        color: Colors.greenAccent,
                                        blurRadius: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30),

                // 🔙 Stylish Back Button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: 180,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.redAccent, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.redAccent.withOpacity(0.8),
                          blurRadius: 20,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          color: Colors.redAccent,
                          size: 22,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Back to Home",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
