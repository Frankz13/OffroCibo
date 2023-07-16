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
class RestaurantSearchDelegate extends SearchDelegate<String>{
  final List<String> restaurantNames;

  RestaurantSearchDelegate(this.restaurantNames);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(onPressed: (){query = '';}, icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Center(child: Text("Risultati di ricerca"));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? []
        : restaurantNames
        .where((name) => name.toLowerCase().startsWith(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index]),
          onTap: () {
            query =suggestionList[index];
            showResults(context);
          },
        );
      },
    );

  }
}
class _UserPageState extends State<UserPage> {
  List<String> docIds = [];
  final TextEditingController searchController = TextEditingController();
  late Future getDocFuture;
  List<String> suggestionList = [];

  void updateSearch(String query) async {
    List<String> restaurantNames = await getRestaurantNames();
    suggestionList = query.isEmpty
        ? []
        : restaurantNames.where((name) => name.toLowerCase().startsWith(query.toLowerCase())).toList();
    setState((){}); // This line tells Flutter to rebuild the UI with the new suggestionList.
  }

  @override
  void initState(){
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

  Future<List<String>> getRestaurantNames() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('food').get();
    List<String> restaurantNames = [];
    snapshot.docs.forEach((doc) {
      if (doc['restaurant_name'] != null) {
        restaurantNames.add(doc['restaurant_name']);
      }
    });

    restaurantNames = restaurantNames.toSet().toList();

    return restaurantNames;
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: updateSearch,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                hintText: 'Cerca per ristorante',
                suffixIcon: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        getDocId(searchController.text); // perform the search when the search button is pressed
                      },
                    ),
                  ],
                ),
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: suggestionList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(suggestionList[index]),
                  onTap: () {
                    searchController.text = suggestionList[index];
                    updateSearch(suggestionList[index]);
                  },
                );
              },
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
      bottomNavigationBar:const BottomNavBar(),
    );

  }
}

