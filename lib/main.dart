// test 2
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_basic/screen/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Initialize Firebase App
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Top Bar
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 106, 255),
        ),

      // Use FutureBuilder for render widget in login.dart => class LoginScreen 
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, AsyncSnapshot snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            return LoginScreen();
          }
          
          // Render widget in login.dart => class LoginScreen position center
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    );
  }
}

