
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsersFilter extends StatefulWidget {
  const UsersFilter({super.key});

  @override
  State<UsersFilter> createState() => _UsersFilterState();
}

class _UsersFilterState extends State<UsersFilter> {

  final Stream<QuerySnapshot> usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  List<QueryDocumentSnapshot> data = [];
  bool isLaoding = true;



  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('age', descending: false)
        .startAt([20]).get();

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
        appBar: AppBar(
          title: const Text('Users'),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          CollectionReference users =
              FirebaseFirestore.instance.collection('users');
          DocumentReference doc1 =
              FirebaseFirestore.instance.collection('users').doc("1");
          DocumentReference doc2 =
              FirebaseFirestore.instance.collection('users').doc("2");
          WriteBatch batch = FirebaseFirestore.instance.batch();

          batch.set(doc1, {"age": 22, "name": "John", "phone": "050255456"});
          batch.set(doc2, {"age": 29, "name": "emad", "phone": "052944827"});
          batch.commit();
        }),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: StreamBuilder(
              stream: usersStream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          // Create a reference to the document the transaction will use
                          DocumentReference documentReference =
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(data[index].id);

                          FirebaseFirestore.instance
                              .runTransaction((transactionHandler) async {
                            DocumentSnapshot snapshot =
                                await transactionHandler.get(documentReference);
                            if (snapshot.exists) {
                              var snapshotData = snapshot.data();

                              if (snapshotData is Map<String, dynamic>) {
                                int age = snapshotData['age'] + 1;
                                transactionHandler.update(documentReference, {
                                  'age': age,
                                });
                              }
                            }
                          }).then((onValue) {});
                        },
                        onDoubleTap: () {
                          // Create a reference to the document the transaction will use
                          DocumentReference documentReference =
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(data[index].id);

                          FirebaseFirestore.instance
                              .runTransaction((transactionHandler) async {
                            DocumentSnapshot snapshot =
                                await transactionHandler.get(documentReference);
                            if (snapshot.exists) {
                              var snapshotData = snapshot.data();

                              if (snapshotData is Map<String, dynamic>) {
                                int age = snapshotData['age'] - 1;
                                transactionHandler.update(documentReference, {
                                  'age': age,
                                });
                              }
                            }
                          }).then((onValue) {});
                        },
                        child: Card(
                            child: ListTile(
                          trailing:
                              Text("${snapshot.data!.docs[index]['age']}"),
                          title: Text(snapshot.data!.docs[index]['name']),
                          subtitle: Text(snapshot.data!.docs[index]['phone']),
                        )),
                      );
                    });
              }),
        ));
  }
}
