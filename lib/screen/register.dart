import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({Key? key});

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
      appBar: AppBar(
        title: Text("Register"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 106, 255),
      ),
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return RegisterScreen();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Create the text field controllers
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  bool passToggle = false;
  final formKey = GlobalKey<FormState>();

  // Register function
  Future<void> createUserUsingEmailPassword() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text,
              password: _passwordController.text);
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
            const Text("Sign Up",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 44.0,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(
              height: 30.0,
            ),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter your email";
                }
                bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value);
                if (!emailValid) {
                  return "Enter a valid email";
                }
                return null;
              },
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.mail,
                  )),
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter your password";
                }
                return null;
              },
              controller: _passwordController,
              obscureText: passToggle,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.lock,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                      passToggle ? Icons.visibility_off : Icons.visibility),
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
            const SizedBox(
              height: 10.0,
            ),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter your password";
                }
                if (value != _passwordController.text) {
                  return "Passwords do not match";
                }
                return null;
              },
              controller: _passwordConfirmController,
              obscureText: passToggle,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.lock,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                      passToggle ? Icons.visibility_off : Icons.visibility),
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
            const SizedBox(
              height: 27.0,
            ),
            Container(
              width: double.infinity,
              child: RawMaterialButton(
                fillColor: const Color.fromARGB(255, 0, 106, 255),
                elevation: 0.0,
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    // Validation successful, create the user
                    await createUserUsingEmailPassword();
                  }
                },
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
