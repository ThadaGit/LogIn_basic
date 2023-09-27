import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_basic/screen/Register.dart';
import 'package:login_basic/screen/profileScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Create the controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Create passToggle to check show or not show password
  bool passToggle = false;

  // Create rememberMe to remember or not remember password
  bool rememberMe = false;

  // Create formKey for control form
  final formKey = GlobalKey<FormState>();

  // Login function
  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("No user found for that email");
      }
    }
    return user;
  }

  // After create widget passToggle = true
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
              // Text 1
              const Text(
                "Task 1",
                // Text 1 Style
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold),
              ),

              // Text 2
              const Text("Login Basic",
                  // Text 2 Style
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 44.0,
                    fontWeight: FontWeight.bold,
                  )),

              // Blank
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

                  // Validator check email valid
                  bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value);
                  if (!emailValid) {
                    return "Enter valid email";
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

              // Remember me checker
              Row(
                children: [
                  Checkbox(
                      value: rememberMe,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value as bool;
                        });
                      }),

                  // Remember me text
                  Text(
                    "Remember me",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),

              // Blank
              const SizedBox(
                height: 15.0,
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
                      User? user = await loginUsingEmailPassword(
                          email: emailController.text,
                          password: passwordController.text,
                          context: context);
                      print(user);

                      // Validation check user != null and rememberMe = false
                      if (formKey.currentState!.validate() &&
                          (user != null) &&
                          (rememberMe == false)) {
                        
                        // When rememberMe = false clear all input
                        emailController.clear();
                        passwordController.clear();

                        // Navigator
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ProfileScreen();
                        }));
                      }

                      // Validation check user != null and rememberMe = true
                      if (formKey.currentState!.validate() &&
                          (user != null) &&
                          (rememberMe == true)) {
                            
                        // Navigator
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ProfileScreen();
                        }));
                      }
                    },

                    // Text Style
                    child: const Text(
                      "Log In",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account yet?",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  TextButton(
                      onPressed: () async {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Register();
                        }));
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ))
                ],
              )
            ],
          ),
        ));
  }
}
