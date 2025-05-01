import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:healthmonitoring/components/textformfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isLoading = false;

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    //this line is for people who pressed sign in with google but then decided to comeback chaged their mind
    //those people will give the googleUser var a null value and if it is a null value it will cause an error
    //and the link with the mark in it
    if (googleUser == null) return;

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    //mark here if googleUser is null the google auth will be null too
    //and cause an error
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushNamedAndRemoveUntil("homepage", (route) => false);
  }

  @override
  void dispose() {
    super.dispose();
    password.dispose();
    email.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? const Center(
                child: Text("Loading...."),
              )
            : Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 30, 4, 46),
                ),
                child: Form(
                  //formState.currentState!.validate() to use this condition we need to create a key
                  key: formState,
                  child: ListView(
                    children: [
                      Container(
                        height: 30,
                      ),
                      Image.asset(
                        "images/icon.png",
                        width: 50,
                        height: 50,
                      ),
                      Container(
                        height: 30,
                      ),
                      const Text(
                        "Login",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Container(
                        height: 10,
                      ),
                      const Text("Login to continue using the app",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromARGB(255, 121, 120, 120))),
                      Container(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          "Email",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      CostumeFormField(
                        hintText: "Example@gmail.com",
                        myController: email,
                        validator: (val) {
                          if (val == '') {
                            return "Can't be empty";
                          }
                          return null;
                        },
                      ),
                      Container(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          "Password",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      CostumeFormField(
                        hintText: "Enter a password",
                        myController: password,
                        validator: (val) {
                          if (val == '') {
                            return "Can't be empty";
                          }
                          return null;
                        },
                      ),
                      Container(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          if (email.text == "") {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'error',
                              desc: 'Please enter an email address first',
                            ).show();
                            return;
                          }
                          try {
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: email.text);
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              animType: AnimType.rightSlide,
                              title: 'Sent',
                              desc:
                                  'An email has been sent to reset your password',
                            ).show();
                          } catch (e) {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.info,
                              animType: AnimType.rightSlide,
                              desc: 'Please check the email then retry',
                            ).show();
                          }
                        },
                        child: Container(
                          child: const Text(
                            "Forgot password?",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 138, 138, 138)),
                          ),
                        ),
                      ),
                      Container(
                        height: 15,
                      ),
                      Container(
                        decoration: const BoxDecoration(),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: const Color.fromARGB(255, 63, 185, 177),
                          onPressed: () async {
                            if (formState.currentState!.validate()) {
                              try {
                                isLoading = true;
                                setState(() {});
                                //this is to login after you have signed in
                                final credential = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: email.text,
                                  password: password.text,
                                );
                                isLoading = false;
                                setState(() {});
                                if (credential.user!.emailVerified) {
                                  //if the email is verified then go to the home page
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      "homepage", (route) => false);
                                } else {
                                  //if the email is not verified then show a dialog box
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.info,
                                    animType: AnimType.rightSlide,
                                    title: 'Verify',
                                    desc:
                                        'Please go to your email address and verify your email',
                                    btnOkOnPress: () {},
                                  ).show();
                                }
                              } on FirebaseAuthException catch (e) {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.info,
                                  animType: AnimType.rightSlide,
                                  title: 'Warning',
                                  desc: 'Wrong password or user name',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () {},
                                ).show();
                                isLoading = false;
                                setState(() {});
                                // Display the Firebase-specific error in the console and handle it
                                if (e.code == 'user-not-found') {
                                  print(
                                      '===================No user found for that email.');
                                } else if (e.code == 'wrong-password') {
                                  print(
                                      '===================Wrong password provided for that user.');
                                } else {
                                  print(
                                      '===================An unknown FirebaseAuthException occurred: ${e.message}');
                                }
                                // You can also show a SnackBar or AlertDialog to display the error message to the user
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          e.message ?? 'Authentication error')),
                                );
                              } catch (e) {
                                // Catch any other type of exception
                                print(
                                    '===================An error occurred: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'An unexpected error occurred. Please try again.')),
                                );
                              }
                            } else {
                              print(
                                  "===============================================Can not be empty.");
                            }
                          },
                          child: const Text("Login"),
                        ),
                      ),
                      Container(
                        height: 20,
                      ),
                      const Text(
                        "Or login with",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      Container(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 370,
                              decoration: const BoxDecoration(),
                              child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  color:
                                      const Color.fromARGB(255, 63, 185, 177),
                                  onPressed: () {
                                    signInWithGoogle();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                        onPressed: () {
                                          signInWithGoogle();
                                        },
                                        child: Row(children: [
                                          const Text("Login with"),
                                          Container(width: 10),
                                          Image.asset(
                                            "images/google.png",
                                            height: 30,
                                            width: 30,
                                          ),
                                        ]),
                                      )
                                    ],
                                  )),
                            ),
                          ]),
                      Container(
                        height: 15,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed("signup");
                          },
                          child: const Center(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Don't have an account? ",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  TextSpan(
                                    text: "Register",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 2, 94, 255)),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                )));
  }
}
