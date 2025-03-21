import 'package:flutter/material.dart';
import 'package:fun_master/love_check_screen.dart';
import 'package:fun_master/meme_lord_screen.dart';
import 'package:fun_master/roast_me_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _buttonController;
  late Animation<double> _buttonScaleAnimation;
  late AnimationController _lottieController;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();

    // 🔥 Smooth Pulsating Effect for Buttons & Lottie
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

    // 🔥 Lottie Animation Controller
    _lottieController = AnimationController(vsync: this);

    // 🔥 Neon Glow Animation Controller (For Buttons)
    _glowController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
      lowerBound: 0.8,
      upperBound: 1.0,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _buttonController.dispose();
    _lottieController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🖼️ Static Background Image (Instead of MP4)
          Positioned.fill(
            child: Image.asset(
              "assets/background.png", // Ensure this file exists in assets/
              fit: BoxFit.cover,
            ),
          ),

          // 🔹 Animated Floating Background Particles (Lottie)
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Lottie.asset("assets/party.json", fit: BoxFit.cover),
            ),
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔥 Bigger & Smoother Animated Lottie (Better Than Mic)
                ScaleTransition(
                  scale: _buttonScaleAnimation,
                  child: Lottie.asset(
                    "assets/mic.json",
                    height: 220,
                    width: 220,
                    controller: _lottieController,
                    onLoaded: (composition) {
                      _lottieController
                        ..duration = composition.duration
                        ..repeat(); // Ensures smooth looping
                    },
                  ),
                ),

                SizedBox(height: 20),

                // 🔹 Glowing Centered Title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "What do you want to do today?",
                    style: GoogleFonts.poppins(
                      fontSize: 28, // Slightly bigger text
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: Colors.cyanAccent, blurRadius: 15),
                        Shadow(color: Colors.deepPurpleAccent, blurRadius: 15),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 50),

                _buildAnimatedNeonButton(
                  "Roast Me",
                  Colors.blueAccent,
                  Icons.mic,
                  context,
                ),

                SizedBox(height: 20),
                _buildAnimatedNeonButton(
                  "LoveChecker",
                  Colors.pinkAccent,
                  Icons.favorite,
                  context,
                ),
                SizedBox(height: 20),
                _buildAnimatedNeonButton(
                  "Meme Lord",
                  Colors.orangeAccent,
                  Icons.insert_emoticon,
                  context,
                ),

                Spacer(),

                // 🔹 Footer Text with Modern Neon Effect
                Text(
                  "🔥 FunMaster • 2025 🔥",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                    shadows: [
                      Shadow(color: Colors.blueAccent, blurRadius: 10),
                      Shadow(color: Colors.purpleAccent, blurRadius: 10),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedNeonButton(
    String text,
    Color color,
    IconData icon,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        if (text == "Roast Me") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoastMeScreen(),
            ), // 🔥 Navigate to Roast Me Screen
          );
        } else if (text == "LoveChecker") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoveCheckerScreen(),
            ), // 🔥 Navigate to Roast Me Screen
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => MemeLordScreen()),
          );
        }
      },
      child: Container(
        width: 270,
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: color, width: 3),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.8),
              blurRadius: 25,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(width: 12),
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
                shadows: [Shadow(color: color, blurRadius: 15)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
