import 'package:flutter/material.dart';
import 'image_upload_screen.dart'; // Next screen we'll create

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  bool _showNameInput = false;

  late AnimationController _titleController;
  late Animation<Offset> _titleOffset;

  @override
  void initState() {
    super.initState();

    // Animation for title moving from center to top
    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _titleOffset = Tween<Offset>(
      begin: const Offset(0, 0), // center
      end: const Offset(0, -0.8), // top middle
    ).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeInOut),
    );

    // Start the animation after 2 seconds, then show name input
    Future.delayed(const Duration(seconds: 2), () {
      _titleController.forward().then((_) {
        setState(() {
          _showNameInput = true;
        });
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF94d3e6), Color(0xFFe0f7fa)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideTransition(
                  position: _titleOffset,
                  child: const Text(
                    'Nail IAlert',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black38,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                if (_showNameInput)
                  Column(
                    children: [
                      SizedBox(
                        width: size.width * 0.7,
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'Enter your name',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          backgroundColor: const Color(0xFF00796B),
                          elevation: 8, // More elevation for 3D effect
                          shadowColor: Colors.black54, // Shadow color
                        ),
                        onPressed: () {
                          if (_nameController.text.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ImageUploadScreen(
                                        userName: _nameController.text,
                                      )),
                            );
                          }
                        },
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFFFAFAFA), // Off-white font color
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
