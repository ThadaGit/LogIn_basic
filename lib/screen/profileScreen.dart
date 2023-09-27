import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Top Bar
      appBar: AppBar(
        title: Text("Welcome"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 106, 255),),

      // Create text position center
      body: Center(
        child: Text("Log in success"),
      ),
    );
  }
}