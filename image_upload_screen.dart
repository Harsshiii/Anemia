import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'results_screen.dart';

class ImageUploadScreen extends StatefulWidget {
  final String userName;
  const ImageUploadScreen({super.key, required this.userName});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  Uint8List? conjunctivaImage;
  Uint8List? fingernailImage;

  final ImagePicker picker = ImagePicker();

  Future<void> pickConjunctivaImage() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        conjunctivaImage = bytes;
      });
    }
  }

  Future<void> pickFingernailImage() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        fingernailImage = bytes;
      });
    }
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Hi, ${widget.userName}!',
                    style: const TextStyle(
                      fontSize: 26, // Increased font size
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _imageCard(
                                'Conjunctiva',
                                conjunctivaImage,
                                pickConjunctivaImage,
                                size.width * 0.35),
                            _imageCard(
                                'Fingernail',
                                fingernailImage,
                                pickFingernailImage,
                                size.width * 0.35),
                          ],
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            backgroundColor: const Color(0xFF00796B),
                          ),
                          onPressed: (conjunctivaImage != null &&
                                  fingernailImage != null)
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ResultsScreen(
                                        conjunctivaImage: conjunctivaImage!,
                                        fingernailImage: fingernailImage!,
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          child: const Text(
                            'Analyze',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFFFAFAFA), // Off-white text
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageCard(
      String label, Uint8List? image, VoidCallback pickImage, double width) {
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
            if (image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  image,
                  width: width - 20,
                  height: width - 60,
                  fit: BoxFit.cover,
                ),
              )
            else
              Icon(Icons.image, size: width / 2, color: Colors.grey[400]),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: pickImage,
              icon: const Icon(Icons.upload_file, color: Color(0xFFFAFAFA)),
              label: Text(
                'Upload $label',
                style: const TextStyle(
                  color: Color(0xFFFAFAFA), // Off-white text
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                backgroundColor: const Color(0xFF00796B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
