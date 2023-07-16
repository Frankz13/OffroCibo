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
  List<String> selectedButtonCategory = [];


  static const List<String> _categories = [
    'Pasta',
    'Pizza',
    'Carne',
    'Pesce',
    'Fritto',
    'Dolce',
  ];

  @override
  void initState() {
    super.initState();
    getDocFuture = getDocId('');
  }

  Future getDocId(String searchTerm) async {
    docIds = [];
    QuerySnapshot snapshot;
    snapshot = await FirebaseFirestore.instance.collection('food').get();

    snapshot.docs.forEach((document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      List<String> documentCategories = List<String>.from(data['category']);

      if ((searchTerm.isEmpty || data['restaurant_name'] == searchTerm) &&
          (selectedButtonCategory.isEmpty || documentCategories.any((element) => selectedButtonCategory.contains(element)))) {
        docIds.add(document.reference.id);
      }
    });
  }

  Future<int> getUserFoodQuantity() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users')
        .where('firebase_auth_user_id', isEqualTo: userId)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot snapshot = querySnapshot.docs.first;
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('food_quantity')) {
        return data['food_quantity'] ?? 0;
      }
    }
    return 0;
  }

  Future<bool> orderFood(String foodDocumentId, String userId) async {
    try {
      DocumentSnapshot foodSnapshot = await FirebaseFirestore.instance.collection('food').doc(foodDocumentId).get();
      Map<String, dynamic> foodData = foodSnapshot.data() as Map<String, dynamic>;
      int foodQuantity = foodData['quantity'] ?? 0;

      QuerySnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').where('firebase_auth_user_id', isEqualTo: userId).get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDocSnapshot = userSnapshot.docs.first;
        Map<String, dynamic> userData = userDocSnapshot.data() as Map<String, dynamic>;
        int userFoodQuantity = userData['food_quantity'] ?? 0;

        await FirebaseFirestore.instance.collection('users').doc(userDocSnapshot.id).update({
          'food_quantity': userFoodQuantity + foodQuantity,
        });
      }

      await FirebaseFirestore.instance.collection('food').doc(foodDocumentId).delete();
      return true;  // Order was successful
    } catch (e) {
      print(e.toString());
      return false;  // An error occurred
    }
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (var category in _categories)
                      ElevatedButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(
                            selectedButtonCategory.contains(category) ? Colors.green : Colors.white,
                          ),
                          ),
                          onPressed: (){
                            setState(() {
                              if (selectedButtonCategory.contains(category)){
                                selectedButtonCategory.remove(category);
                              }else {
                                selectedButtonCategory.add(category);
                              }
                              getDocFuture = getDocId(searchController.text);
                            });
                          },
                          child:Text(category,
                              style: TextStyle(
                                  color: selectedButtonCategory.contains(category) ? Colors.white : Colors.black)))
                  ]
              ),
            ),

            FutureBuilder<int>(
              future: getUserFoodQuantity(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  return Text("Cibo recuperato = ${snapshot.data}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),);
                }
              },
            ),
            Expanded(
              child: FutureBuilder(
                future: getDocFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (docIds.isEmpty) {
                    return const Center(child: Text("Wow abbiamo finito tutto! Sembra un sogno... oppure c'è un errore :( ",
                    textAlign: TextAlign.center,));
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
                                      child: ReusableWidgets.buildButton('Ordina', (){
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context)
                                        {
                                          return AlertDialog(
                                            title: const Text('Conferma ordine'),
                                            content: const Text("Sei sicuro di voler confermare l'ordine?"),
                                            actions: <Widget>[
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child:
                                              const Text('Annulla')),
                                              TextButton(onPressed: () async {
                                                String userId = FirebaseAuth.instance.currentUser!.uid;
                                                bool orderSuccess = await orderFood(docIds[index], userId);
                                                Navigator.of(context).pop();

                                                if (orderSuccess) {
                                                  setState(() {
                                                    getDocFuture = getDocId(searchController.text);
                                                  });
                                                } else {
                                                  const Text('Errore');
                                                }


                                              },
                                                  child: const Text("Conferma"))
                                            ],
                                          );
                                        });
                                      }
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
