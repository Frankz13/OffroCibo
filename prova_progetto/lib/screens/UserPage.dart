import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prova_progetto/read%20data/getUserName.dart';
import 'package:prova_progetto/screens/Login.dart';
import 'package:prova_progetto/widgets/BottomNavBar.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  InputDecoration decoration(String label) {
    return const InputDecoration();
  }

  //documnets ids

  List<String> docIds = [];

  //get documents ids

  Future getDocId() async {
    await FirebaseFirestore.instance.collection('food').get()
        .then((snapshot) => snapshot.docs.forEach((document) {
          print(document.reference);
          docIds.add(document.reference.id);
    }));
  }

  @override


  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(title:  const Text(
        "Bentornato! Le tue offerte:",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
        actions: [
          IconButton(onPressed: (){
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));},
            icon: const Icon(Icons.logout),
          ),

        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder(
                  future: getDocId(),
                  builder: (context, snapshot){
                return ListView.builder(
                  itemCount: docIds.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        tileColor: Colors.pink,
                        title: GetUserName(documentId: docIds[index]),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),

      bottomNavigationBar: const BottomNavBar(),


    );
  }


  }

