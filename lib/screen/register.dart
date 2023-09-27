import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

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
        title: Text("Register"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 106, 255),
      ),

      // Use FutureBuilder for render widget in class RegisterScreen 
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return RegisterScreen();
          }

          // Render widget in RegisterScreen position center
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  // Create the controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // Create passToggle to check show or not show password
  bool passToggle = false;

  // Create formKey for control form
  final formKey = GlobalKey<FormState>();

  // Register function
  Future<void> createUserUsingEmailPassword() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text);
      User? user = userCredential.user;
      if (user != null) {
        
        // Registration successful, you can navigate to the next screen or perform other actions here
        Navigator.pop(context);
        ;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        print("The password provided is too weak.");
      } else if (e.code == "email-already-in-use") {
        print("The account already exists for that email.");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    passToggle = true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Text
            const Text("Sign Up",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 44.0,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(
              height: 30.0,
            ),

            // Email
            TextFormField(
              validator: (value) {

                // Validator check email not empty
                if (value!.isEmpty) {
                  return "Enter your email";
                }

                // Validator check email not empty
                if (value != Null) {
                  return "Enter your email";
                }

                // Validator check email valid
                bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value);
                if (!emailValid) {
                  return "Enter a valid email";
                }
                return null;
              },

              // Email controller
              controller: emailController,

              // Keyboard type
              keyboardType: TextInputType.emailAddress,

              // Decoration (Input)
              decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.mail,
                  )),
            ),

            // Blank
            const SizedBox(
              height: 10.0,
            ),

            // Password
            TextFormField(
              validator: (value) {

                // Validator check password not empty
                if (value!.isEmpty) {
                  return "Enter your password";
                }
                return null;
              },

              // Password controller
              controller: passwordController,

              // Control show or not show by passToggle
              obscureText: passToggle,

              // Decoration (Input)
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.lock,
                ),

                // Icon button
                suffixIcon: IconButton(
                  icon: Icon(
                      passToggle ? Icons.visibility_off : Icons.visibility),

                  // When click icon change passToggle true => false or false => true
                  onPressed: () {
                    setState(() {
                      passToggle = !passToggle;
                    });
                  },
                ),
                alignLabelWithHint: false,
                filled: true,
              ),
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
            ),

            // Blank
            const SizedBox(
              height: 10.0,
            ),

            // Confirm password
            TextFormField(

              // Validator
              validator: (value) {

                // Validator check confirm password not empty
                if (value!.isEmpty) {
                  return "Enter your password";
                }

                // Validator check confirm password not match password
                if (value != passwordController.text) {
                  return "Passwords do not match";
                }
                return null;
              },

              // Confirm password controller
              controller: confirmPasswordController,

              // Control show or not show by passToggle
              obscureText: passToggle,

              // Decoration (Input)
              decoration: InputDecoration(
                labelText: "Confirm Password",
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.lock,
                ),

                // Icon button
                suffixIcon: IconButton(
                  icon: Icon(
                      passToggle ? Icons.visibility_off : Icons.visibility),

                  // When click icon change passToggle true => false or false => true
                  onPressed: () {
                    setState(() {
                      passToggle = !passToggle;
                    });
                  },
                ),
                alignLabelWithHint: false,
                filled: true,
              ),
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
            ),

            // Blank
            const SizedBox(
              height: 27.0,
            ),

            // Button
            Container(
              width: double.infinity,

              // Button Style
              child: RawMaterialButton(
                fillColor: const Color.fromARGB(255, 0, 106, 255),
                elevation: 0.0,
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),

                // When onPressed
                onPressed: () async {

                  // Validation
                  if (formKey.currentState!.validate()) {

                    // Validation successful, create the user
                    await createUserUsingEmailPassword();
                  }
                },

                // Text Style
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
