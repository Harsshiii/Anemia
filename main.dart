import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const NailIAlertApp());
}

class NailIAlertApp extends StatelessWidget {
  const NailIAlertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nail IAlert',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const HomeScreen(),
    );
  }
}
