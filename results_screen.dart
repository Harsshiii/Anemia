import 'dart:typed_data';
import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final Uint8List conjunctivaImage;
  final Uint8List fingernailImage;

  // For demo, we'll hardcode a prediction. Later, integrate your ML model.
  final bool isAnaemic;

  const ResultsScreen({
    super.key,
    required this.conjunctivaImage,
    required this.fingernailImage,
    this.isAnaemic = true, // default for demo
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final resultText = isAnaemic ? "Anaemic" : "Non-Anaemic";
    final adviceText =
        isAnaemic ? "Do consult a doctor" : "Keep up! Be healthy";
    final resultColor = isAnaemic ? Colors.redAccent : Colors.green;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF94d3e6), Color(0xFFe0f7fa)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'Analysis Results',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                        blurRadius: 4,
                        color: Colors.black38,
                        offset: Offset(2, 2))
                  ]),
            ),
            const SizedBox(height: 30),
            // Images row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _imageCard('Conjunctiva', conjunctivaImage, size.width * 0.4),
                _imageCard('Fingernail', fingernailImage, size.width * 0.4),
              ],
            ),
            const SizedBox(height: 40),
            // Result card
            Container(
              width: size.width * 0.7,
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [resultColor.withOpacity(0.8), resultColor],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(3, 3),
                  )
                ],
              ),
              child: Column(
                children: [
                  Text(
                    resultText,
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    adviceText,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _imageCard(String label, Uint8List image, double width) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Container(
        width: width,
        height: width,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  image,
                  width: width - 20,
                  height: width - 60,
                  fit: BoxFit.cover,
                )),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
