import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prova_progetto/screens/AddingProductPage.dart';
import 'package:prova_progetto/screens/Login.dart';
import 'package:prova_progetto/read%20data/getUserName.dart';
import 'package:prova_progetto/widgets/BottomNavBar.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({Key? key}) : super(key: key);

  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  List<String> docIds = [];

  Future getDocId() async {
    await FirebaseFirestore.instance.collection('food').get()
        .then((snapshot) => snapshot.docs.forEach((document) {
      docIds.add(document.reference.id);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bentornato! Le tue offerte:",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: (){
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage())
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder(
                future: getDocId(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (docIds.isEmpty) {
                    return const Center(child: Text("Per favore crea un' inserzione"));
                  } else {
                    return ListView.builder(
                      itemCount: docIds.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.orange,
                          shadowColor: Colors.purple,
                          elevation: 50,
                          margin: const EdgeInsets.all(20),
                          clipBehavior: Clip.hardEdge,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.asset(
                                  'images/pizza.jpg',
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GetFoodName(documentId: docIds[index]),
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("pizza"),
                                        Text("pasta"),
                                        Text("dolci"),
                                        Text("pesce"),
                                        Text("carne"),
                                      ],
                                    ),
                                    GetFoodQuantity(documentId: docIds[index]),
                                    const Text('Ristorante:'),
                                    GetRestaurantName(documentId: docIds[index]),
                                    const Text('Indirizzo:'),
                                    GetRestaurantAddress(documentId: docIds[index]),
                                    GetFoodDate(documentId: docIds[index]),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {},
                                          child: const Icon(Icons.edit_note),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {},
                                          child: const Icon(Icons.delete_forever),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            )],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButton: ClipOval(
        child: FloatingActionButton(
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddingProductPage())
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}