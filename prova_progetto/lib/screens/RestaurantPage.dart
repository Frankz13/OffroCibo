import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prova_progetto/screens/AddingProductPage.dart';
import 'package:prova_progetto/screens/Login.dart';
import 'package:prova_progetto/read%20data/getFoodData.dart';
import 'package:prova_progetto/widgets/BottomNavBar.dart';
import 'package:prova_progetto/screens/EditProductPage.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({Key? key}) : super(key: key);

  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  List<String> docIds = [];

  Future getDocId() async {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    await FirebaseFirestore.instance
        .collection('food')
        .where('user_id', isEqualTo: currentUserId) // this line filters the documents
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
      docIds.add(document.reference.id);
    }));
  }

  Future<DocumentSnapshot> getDocument(String docId) async {
    return await FirebaseFirestore.instance.collection('food').doc(docId).get();
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
                                    GetFoodName(documentId: docIds[index]),
                                    const Text("Categoria/e: "),
                                    GetCategory(documentId: docIds[index]),
                                    Row(
                                      children: [
                                        const Text("Quantità: "),
                                        GetFoodQuantity(documentId: docIds[index]),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text('Ristorante: '),
                                        GetRestaurantName(documentId: docIds[index]),
                                      ],
                                    ),

                                    const Text('Indirizzo:'),
                                    GetRestaurantAddress(documentId: docIds[index]),
                                    GetFoodDate(documentId: docIds[index]),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            DocumentSnapshot document = await getDocument(docIds[index]);
                                            var docData = document.data() as Map<String, dynamic>?;
                                            if (docData != null) {
                                              List<String> categoryList = (docData['category'] as List<dynamic>)
                                                  .map((item) => item.toString())
                                                  .toList();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => EditPage(
                                                  documentId: document.id,
                                                  nameProduct: docData['name_product'],
                                                  restaurantName: docData['restaurant_name'],
                                                  restaurantAddress: docData['restaurant_address'],
                                                  date: docData['date'].toDate(),
                                                  quantity: docData['quantity'],
                                                  category: categoryList,
                                                  imageUrl: docData['image_url']
                                                )),
                                              );
                                            } else {
                                              // Handle the case when the document data is null
                                            }



                                          },
                                          child: const Icon(Icons.edit_note),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text('Attenzione !'),
                                                    content: const Text('Sei sicuro di voler eliminare questa offerta?'),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: (){
                                                            FirebaseFirestore.instance.collection('food').doc(docIds[index]).delete().then((_) {
                                                              Navigator.pushReplacement(
                                                                context,
                                                                PageRouteBuilder(
                                                                  pageBuilder: (context, animation1, animation2) => const RestaurantPage(),
                                                                  transitionDuration: Duration.zero,
                                                                ),
                                                              );
                                                            });
                                                          },
                                                          child: const Text('Sì, elimina')
                                                      ),
                                                      TextButton(
                                                          onPressed: (){Navigator.of(context).pop();},
                                                          child: const Text('Indietro')
                                                      ),
                                                    ],
                                                  );
                                                }
                                            );
                                          },
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
            ),
          ],
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
