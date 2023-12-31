import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prova_progetto/widgets/ReausableWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}

class AddingProductPage extends StatefulWidget {
  const AddingProductPage({Key? key}) : super(key: key);
  


  @override
  _AddingProductPageState createState() => _AddingProductPageState();
}

class _AddingProductPageState extends State<AddingProductPage> {
  final controllerNameProduct = TextEditingController();
  final controllerQuantity = TextEditingController();
  final controllerDate = TextEditingController();
  final controllerRestaurantName = TextEditingController();
  final controllerRestaurantAddress = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();




  List<String> selectedButtonCategory = [];

  static const List<String> _categories = [
    'Pasta',
    'Pizza',
    'Carne',
    'Pesce',
    'Fritto',
    'Dolce',
  ];

  Future pickImageGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  Future pickImageCamera() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 700,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white,
              elevation: 50,
              shadowColor: Colors.deepPurple,
              child: Scrollbar(
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: <Widget>[
                     Padding(
                      padding: const EdgeInsets.all(8.0),

                      child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Aggiungi un'offerta",
                      style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                      ),
                              IconButton(
                                  icon: const Icon(Icons.highlight_remove),
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                  },
                              ),

                            ],
                          )
                      ),
                    ),
                    ReusableWidgets.buildTextField('Nome del prodotto:',
                        controller: controllerNameProduct),
                    const SizedBox(height: 16),
                    const Text('Categoria: ',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                      textAlign: TextAlign.center,
                    ),
                    Wrap(
                        alignment: WrapAlignment.center,
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
                                  });
                                },
                                child:Text(category,
                                    style: TextStyle(
                                        color: selectedButtonCategory.contains(category) ? Colors.white : Colors.black)))
                        ]
                    ),
                    const SizedBox(height: 16),

                    ReusableWidgets.buildTextField('Nome Ristorante:',
                        controller: controllerRestaurantName),
                    const SizedBox(height: 16),
                    ReusableWidgets.buildTextField('Indirizzo Ristorante:',
                        controller: controllerRestaurantAddress),
                    const SizedBox(height: 16),
                    ReusableWidgets.buildTextField('Numero porzioni:',
                        controller: controllerQuantity,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 16),
                    ReusableWidgets.buildDateTimeField(
                        controller: controllerDate,
                        hint: "Data di produzione:"),
                    const SizedBox(height: 24),
                    const Text("Carica un'immagine:"),



                    (_image != null)
                        ? Container(
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(_image!),
                          fit: BoxFit.cover,
                        )
                      ),

                    )
                        : Container(
                        height: 200,
                        color: Colors.white60
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        children: [
                          ReusableWidgets.buildButton('Camera', () {
                            pickImageCamera();
                          }),
                          ReusableWidgets.buildButton('Galleria', () {
                            pickImageGallery();
                          })
                        ],
                      ),
                    ),
                    ReusableWidgets.buildButton('Crea', () {


                  if(controllerNameProduct.text.isEmpty ||
                      controllerQuantity.text.isEmpty ||
                      controllerDate.text.isEmpty ||
                      controllerRestaurantName.text.isEmpty ||
                      controllerRestaurantAddress.text.isEmpty ||
                      selectedButtonCategory.isEmpty)
                  {

                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Errore'),
                            content: const Text('Inserisci tutti i campi'),
                            actions: [
                              TextButton(
                                  onPressed: (){Navigator.of(context).pop();},
                                  child: const Text('Ok')),
                            ],
                          );
                        }
                    );
                    return;
                  }else {
                    selectedButtonCategory.sort();
                    final food = Food(
                      nameProduct: controllerNameProduct.text.capitalize(),
                      quantity: int.parse(controllerQuantity.text),
                      date: DateFormat('yyyy-MM-dd').parse(controllerDate.text),
                      restaurantName: controllerRestaurantName.text.capitalize(),
                      restaurantAddress: controllerRestaurantAddress.text.capitalize(),
                      userId: '',
                      category: selectedButtonCategory,
                    );
                    createFood(food);
                    Navigator.pop(context);
                  }
                }),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

  }

  Future<void> createFood(Food food) async {
    final docFood = FirebaseFirestore.instance.collection('food').doc();
    food.userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('food_images').child('${docFood.id}.png');

    String imageUrl = '';
    if (_image != null) {
      await ref.putFile(_image!);
      imageUrl = await ref.getDownloadURL();
    }

    final json = food.toJson();
    await docFood.set({...json, 'image_url': imageUrl});
  }
}

class Food {
  String? userId;
  final String? nameProduct;
  final int? quantity;
  final DateTime? date;
  final String? restaurantName;
  final String? restaurantAddress;
  final List<String> category;

  Food({
    required this.userId,
    required this.nameProduct,
    required this.quantity,
    required this.date,
    required this.restaurantName,
    required this.restaurantAddress,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name_product': nameProduct,
      'quantity': quantity,
      'date': date != null ? Timestamp.fromDate(date!) : null,
      'restaurant_name': restaurantName,
      'restaurant_address': restaurantAddress,
      'category': category,

    };
  }
}

