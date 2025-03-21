import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';

class MemeLordScreen extends StatefulWidget {
  const MemeLordScreen({super.key});

  @override
  _MemeLordScreenState createState() => _MemeLordScreenState();
}

class _MemeLordScreenState extends State<MemeLordScreen> {
  final TextEditingController _topTextController = TextEditingController();
  final TextEditingController _bottomTextController = TextEditingController();
  final ScreenshotController _screenshotController = ScreenshotController();
  File? _image;

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _saveAndShareMeme() async {
    try {
      final image = await _screenshotController.capture();
      if (image == null) return;

      final directory = await getTemporaryDirectory();
      final imagePath = File('${directory.path}/meme.png');
      await imagePath.writeAsBytes(image);

      await Share.shareXFiles([
        XFile(imagePath.path),
      ], text: 'Check out my meme! 😂');
    } catch (e) {
      print("Error saving and sharing meme: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🎨 Cyberpunk Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade900, Colors.blueGrey.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🔥 Animated Title
                  ListTile(
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios_rounded),
                    ),
                    title: Text(
                      "MEME LORD 😂",
                      style: GoogleFonts.orbitron(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent,
                        shadows: [
                          Shadow(color: Colors.blueAccent, blurRadius: 15),
                          Shadow(color: Colors.purpleAccent, blurRadius: 15),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      padding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 30,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _pickImage,
                    child: Text(
                      "Pick an Image",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  Screenshot(
                    controller: _screenshotController,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(115, 175, 42, 42),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _image != null
                              ? Image.file(
                                _image!,
                                height: 300,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                              : Image.asset(
                                "assets/meme_template.jpg",
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                          Positioned(
                            top: 20,
                            child: Text(
                              _topTextController.text.toUpperCase(),
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(color: Colors.black, blurRadius: 5),
                                ],
                                backgroundColor: const Color.fromARGB(
                                  137,
                                  246,
                                  91,
                                  91,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            child: Text(
                              _bottomTextController.text.toUpperCase(),
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: const Color.fromARGB(
                                      255,
                                      238,
                                      95,
                                      95,
                                    ),
                                    blurRadius: 5,
                                  ),
                                ],
                                backgroundColor: const Color.fromARGB(
                                  137,
                                  246,
                                  91,
                                  91,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // 🔹 Top Text Field
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextField(
                      controller: _topTextController,
                      decoration: InputDecoration(
                        labelText: "Top Text",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                  ),

                  // 🔹 Bottom Text Field
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextField(
                      controller: _bottomTextController,
                      decoration: InputDecoration(
                        labelText: "Bottom Text",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                  ),
                  SizedBox(height: 20),
                  // 🔥 Share Meme Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      padding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 30,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _saveAndShareMeme,
                    child: Text(
                      "Save & Share",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
