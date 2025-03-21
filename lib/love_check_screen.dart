import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoveCheckerScreen extends StatefulWidget {
  const LoveCheckerScreen({super.key});

  @override
  _LoveCheckerScreenState createState() => _LoveCheckerScreenState();
}

class _LoveCheckerScreenState extends State<LoveCheckerScreen> {
  final TextEditingController _nameController1 = TextEditingController();
  final TextEditingController _nameController2 = TextEditingController();
  bool _buttonGlitch = false; // Detect hover state

  @override
  void initState() {
    super.initState();

    // 🔥 Glitch effect will run every second
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {}); // Refresh UI to change the title randomly
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Background Gradient (Cyberpunk Look)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade900, Colors.blueGrey.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  child: Text(
                    _getGlitchText(), // Function that returns a random glitch text
                    key: ValueKey(_glitchKey), // Key to trigger animation
                    style: GoogleFonts.orbitron(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent,
                      shadows: [
                        Shadow(color: Colors.blueAccent, blurRadius: 15),
                        Shadow(color: Colors.purpleAccent, blurRadius: 15),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // 🔹 Name Input Fields (Glowing Effect)
                _buildGlowingTextField("Your Name", _nameController1),
                SizedBox(height: 20),
                _buildGlowingTextField("Crush's Name", _nameController2),

                SizedBox(height: 40),

                MouseRegion(
                  onEnter: (_) => setState(() => _buttonGlitch = true),
                  onExit: (_) => setState(() => _buttonGlitch = false),
                  child: ElevatedButton(
                    onPressed: _startLoveTest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _buttonGlitch ? Colors.cyanAccent : Colors.pinkAccent,
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 40,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      shadowColor: Colors.pinkAccent.withOpacity(0.6),
                      elevation: 10,
                    ),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      child: Text(
                        _isProcessing ? "🔄 SCANNING..." : "💖 Start Love Test",
                        key: ValueKey(_isProcessing),
                        style: GoogleFonts.orbitron(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // 🔙 Stylish Back Button
                GestureDetector(
                  onTap: () => Navigator.pop(context), // ✅ Go back to Home
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: 200,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.blueAccent, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.8),
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
                          color: Colors.blueAccent,
                          size: 22,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Back to Home",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                            shadows: [
                              Shadow(color: Colors.blueAccent, blurRadius: 10),
                            ],
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

  bool _isProcessing = false;

  void _startLoveTest() {
    if (_nameController1.text.trim().isEmpty ||
        _nameController2.text.trim().isEmpty) {
      _showErrorPopup(
        "Both names must be entered before starting the test! 🚨",
      );
      return;
    }

    setState(() {
      _isProcessing = true; // Show "Scanning..." text
    });

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isProcessing = false;
        _showLoveResult(); // After scan, show result
      });
    });
  }

  void _showErrorPopup(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.85),
          title: Text(
            "⚠️ Warning!",
            style: GoogleFonts.orbitron(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          content: Text(
            message,
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "OKAY",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLoveResult() {
    int lovePercentage = Random().nextInt(101); // 0 - 100%

    List<String> funnyResults = [
      "You're soulmates! ❤️🔥",
      "This might work... Maybe! 🤔",
      "A risky love story! 😅",
      "Oof! Just stay friends. 😂",
      "RUN! This love is dangerous! 🚨",
    ];

    String loveMessage = funnyResults[Random().nextInt(funnyResults.length)];

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Cyberpunk Glass Effect
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.85),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.pinkAccent, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.pinkAccent.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🎆 Animated Love Percentage
                TweenAnimationBuilder(
                  tween: Tween<double>(
                    begin: 0,
                    end: lovePercentage.toDouble(),
                  ),
                  duration: Duration(seconds: 2),
                  builder: (context, double value, child) {
                    return Text(
                      "💖 Love Compatibility: ${value.toInt()}%",
                      style: GoogleFonts.orbitron(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                        shadows: [
                          Shadow(color: Colors.blueAccent, blurRadius: 15),
                          Shadow(color: Colors.purpleAccent, blurRadius: 15),
                        ],
                      ),
                    );
                  },
                ),

                SizedBox(height: 10),

                // 🔥 Neon Glitchy Result Message
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  child: Text(
                    loveMessage,
                    key: ValueKey(loveMessage),
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: Colors.cyanAccent, blurRadius: 10),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 20),

                // 🏆 Close Button with Glow Effect
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
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
                    child: Text(
                      "OKAY 💔",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                        shadows: [
                          Shadow(color: Colors.redAccent, blurRadius: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  int _glitchKey = 0; // Used to trigger AnimatedSwitcher

  String _getGlitchText() {
    List<String> glitchTexts = [
      "LOVE CHECKER ❤️",
      "LØVE CHΞCKER 🖤",
      "LΩVΞ CH3CK3R 🔥",
      "LØVΞ CHΞKΞR ❤️‍🔥",
      "L💖VΞ CHΞCKΞR",
    ];
    _glitchKey++; // Change key to refresh animation
    return glitchTexts[Random().nextInt(glitchTexts.length)];
  }

  Widget _buildGlowingTextField(String hint, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white54),
          filled: true,
          fillColor: Colors.black.withOpacity(0.3),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.pinkAccent, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.cyanAccent, width: 3),
          ),
        ),
      ),
    );
  }
}
