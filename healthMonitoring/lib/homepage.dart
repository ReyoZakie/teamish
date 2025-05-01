import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:healthmonitoring/components/cardmonitor.dart';
import 'package:healthmonitoring/components/edit.dart';
import 'package:healthmonitoring/note/view.dart';
import 'package:healthmonitoring/users.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<QueryDocumentSnapshot> data = [];
  bool isLaoding = true;

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('patient')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    data.addAll(querySnapshot.docs);
    isLaoding = false;
    setState(() {});
  }

  @override
  void initState() {
    isLaoding = true;
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('addfile');
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("hello"),
        actions: [
          IconButton(
              onPressed: () async {
                GoogleSignIn googleSignIn = GoogleSignIn();
                googleSignIn.disconnect();
                await FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("login", (route) => false);
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: isLaoding ==
              true //here we r saying if islaoding is true then show the text laoding otherwise show the gridview
          ? const Center(
              child: Text("Laoding...."),
            )
          : Column(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 100,
                    child: GridView.builder(
                        itemCount: data.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemBuilder: (context, i) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ViewNote(patientId: data[i].id)));
                            },
                            onLongPress: () async {
                              AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.info,
                                  animType: AnimType.rightSlide,
                                  desc: 'What do you need',
                                  btnCancelText: "Delete",
                                  btnCancelOnPress: () async {
                                    await FirebaseFirestore.instance
                                        .collection('patient')
                                        .doc(data[i].id)
                                        .delete();
                                    Navigator.of(context)
                                        .pushReplacementNamed('homepage');
                                  },
                                  btnOkText: "Update",
                                  btnOkOnPress: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => EditPatient(
                                                docId: data[i].id,
                                                oldName: data[i]["patient"])));
                                  }).show();
                            },
                            child: CardMonitor(
                                measurement: "99",
                                measurementType: "${data[i]["patient"]}"),
                          );
                        }),
                  ),
                ),
                Container(
                    color: Colors.green,
                    height: 50,
                    width: 150,
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const UsersFilter()));
                      },
                      child: const Text('Users'),
                    ))
              ],
            ),
    );
  }
}
