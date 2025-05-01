import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthmonitoring/components/textformfield.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _LoginState();
}

class _LoginState extends State<Signup> {
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    userName.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 30, 4, 46),
            ),
            child: Form(
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
                    "Signup",
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
                      style:
                          TextStyle(color: Color.fromARGB(255, 121, 120, 120))),
                  Container(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      "Username",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  CostumeFormField(
                      hintText: "Enter your username",
                      myController: userName,
                      validator: (val) {
                        if (val == '') {
                          return "Can't be empty";
                        }
                        return null;
                      }),
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
                  const Text(
                    "Forgot password?",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 138, 138, 138)),
                  ),
                  Container(
                    height: 15,
                  ),
                  Container(
                    decoration: const BoxDecoration(),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      color: const Color.fromARGB(255, 63, 185, 177),
                      onPressed: () async {
                        if (formState.currentState!.validate()) {
                          try {
                            //here is where we create an intance of user for the first time
                            final credential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: email.text,
                              password: password.text,
                            );
                            //send varification email
                            FirebaseAuth.instance.currentUser!
                                .sendEmailVerification();
                            //go to login page
                            Navigator.of(context).pushReplacementNamed('login');
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              print('The password provided is too weak.');
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Warning',
                                desc: 'The password provided is too weak.',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {},
                              ).show();
                            } else if (e.code == 'email-already-in-use') {
                              print(
                                  'The account already exists for that email.');
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Warning',
                                desc:
                                    'The account already exists for that email.',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {},
                              ).show();
                            }
                          } catch (e) {
                            print(e);
                          }
                        } else {
                          //if the fields are empty
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Warning',
                            desc: 'Not valid',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {},
                          ).show();
                        }
                      },
                      child: const Text("Signup"),
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed("login");
                      },
                      child: const Center(
                        child: Text.rich(TextSpan(children: [
                          TextSpan(
                              text: "have an account? ",
                              style: TextStyle(color: Colors.white)),
                          TextSpan(
                              text: "login",
                              style: TextStyle(color: Colors.blue))
                        ])),
                      ))
                ],
              ),
            )));
  }
}
