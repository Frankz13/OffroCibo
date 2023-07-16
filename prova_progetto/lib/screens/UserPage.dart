import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prova_progetto/read%20data/getFoodData.dart';
import 'package:prova_progetto/screens/Login.dart';
import 'package:prova_progetto/widgets/BottomNavBar.dart';
import '../widgets/ReausableWidgets.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<String> docIds = [];
  final TextEditingController searchController = TextEditingController();
  late Future getDocFuture;

  @override
  void initState() {
    super.initState();
    getDocFuture = getDocId('');
  }

  Future getDocId(String searchTerm) async {
    docIds = [];
    QuerySnapshot snapshot;
    if (searchTerm.isEmpty){
      snapshot = await FirebaseFirestore.instance.collection('food').get();
    }else {
      snapshot = await FirebaseFirestore.instance
          .collection('food')
          .where('restaurant_name', isEqualTo: searchTerm)
          .get();}
    snapshot.docs.forEach((document) {
      docIds.add(document.reference.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ecco le offerte per te:",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: 'Cerca per ristorante',
                    suffixIcon: Row(mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        IconButton(icon: const Icon(Icons.clear), onPressed: () {
                          searchController.clear();
                        },),
                        IconButton(icon: const Icon(Icons.search), onPressed: () {
                          setState(() {
                            setState(() {
                              getDocFuture = getDocId(searchController.text);
                            });

                          });
                        },),

                      ],
                    )
                ),

                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Text(
              "pizza pesce pasta carne dolci fritto",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: FutureBuilder(
                future: getDocFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (docIds.isEmpty) {
                    return const Center(child: Text("Wow abbiamo finito tutto! Sembra un sogno... oppure c'è un errore :( "));
                  } else {
                    return ListView.builder(
                      itemCount: docIds.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),

                          shadowColor: Colors.white,
                          elevation: 50,
                          margin: const EdgeInsets.all(20),
                          clipBehavior: Clip.hardEdge,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: GetImageUrl(documentId: docIds[index])
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(child: GetFoodName(documentId: docIds[index])),

                                    Center(child: GetCategory(documentId: docIds[index])),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text("Quantità: "),
                                        GetFoodQuantity(documentId: docIds[index]),
                                      ],
                                    ),
                                    Center(child: GetRestaurantName(documentId: docIds[index])),

                                    Center(child: GetRestaurantAddress(documentId: docIds[index])),
                                    Center(child: GetFoodDate(documentId: docIds[index])),

                                    Center(
                                      child: ReusableWidgets.buildButton('Ordina', (){}
                                      ),
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
            ),
          ],
        ),
      ),
      bottomNavigationBar:const BottomNavBar(),
    );

  }
}
