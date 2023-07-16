import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prova_progetto/screens/AddingProductPage.dart';
import 'package:prova_progetto/widgets/ReausableWidgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';


class EditPage extends StatefulWidget {
  final String documentId;
  final String nameProduct;
  final String restaurantName;
  final String restaurantAddress;
  final DateTime date;
  final int quantity;
  final List<String> category;
  String imageUrl;

  EditPage({
    required this.documentId,
    required this.nameProduct,
    required this.restaurantName,
    required this.restaurantAddress,
    required this.date,
    required this.quantity,
    required this.category,
    required this.imageUrl,
  });

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late final TextEditingController nameProductController;
  late final TextEditingController restaurantNameController;
  late final TextEditingController restaurantAddressController;
  late final TextEditingController quantityController;
  late final TextEditingController dateController;
  List<String> selectedButtonCategory = [];

  File? _image;
  late final ImagePicker _picker = ImagePicker();
  late final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> pickImageGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file =File(pickedFile.path);
      setState(() {
        _image = file;
      });
    } else {
      print('No image selected.');
    }
  }

  Future<void> pickImageCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final file =File(pickedFile.path);
      setState(() {
        _image = file;
      });
    } else {
      print('No image selected.');
    }
  }


  Future<String?> uploadImage() async {
    if (_image != null) {
      final snapshot = await _storage.ref('images/${widget.documentId}').putFile(_image!);
      return await snapshot.ref.getDownloadURL();
    }
    return null;
  }

  Future<void> updateFood(Food food) async {
    food.userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final json = food.toJson();

    // upload the image and get the URL
    String? imageUrl = await uploadImage();

    if (imageUrl != null) {
      json['image_url'] = imageUrl;
    }

    final docFood =
    FirebaseFirestore.instance.collection('food').doc(widget.documentId);

    await docFood.update(json);
  }




  @override
  void initState() {
    super.initState();
    nameProductController = TextEditingController(text: widget.nameProduct);
    restaurantNameController =
        TextEditingController(text: widget.restaurantName);
    restaurantAddressController =
        TextEditingController(text: widget.restaurantAddress);
    quantityController =
        TextEditingController(text: widget.quantity.toString());
    dateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(widget.date));
    selectedButtonCategory = List.from(widget.category);
  }

  @override
  void dispose() {
    nameProductController.dispose();
    restaurantNameController.dispose();
    restaurantAddressController.dispose();
    quantityController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const List<String> _categories = [
      'Pasta',
      'Pizza',
      'Carne',
      'Pesce',
      'Fritto',
      'Dolce',




    ];

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
                            const Text(
                              "Modifica l'offerta",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.highlight_remove),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    ReusableWidgets.buildTextField('Nome del Prodotto',
                        controller: nameProductController),
                    const SizedBox(height: 16),
                    const Text(
                      'Categoria: ',
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
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                selectedButtonCategory.contains(category)
                                    ? Colors.green
                                    : Colors.white,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                if (selectedButtonCategory.contains(category)) {
                                  selectedButtonCategory.remove(category);
                                } else {
                                  selectedButtonCategory.add(category);
                                }
                              });
                            },
                            child: Text(category,
                                style: TextStyle(
                                    color: selectedButtonCategory
                                        .contains(category)
                                        ? Colors.white
                                        : Colors.black)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ReusableWidgets.buildTextField('Nome del Ristorante',
                        controller: restaurantNameController),
                    const SizedBox(height: 16),
                    ReusableWidgets.buildTextField('Indirizzo del Ristorante',
                        controller: restaurantAddressController),
                    const SizedBox(height: 16),
                    ReusableWidgets.buildTextField('Quantità',
                        controller: quantityController,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 16),
                    ReusableWidgets.buildDateTimeField(
                        controller: dateController,
                        hint: "Data di produzione:"),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        _image == null
                        ? Container(
                          height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(widget.imageUrl),
                                fit: BoxFit.cover,
                              )
                            ),
                            )
                        : Container(
                          height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(_image!),
                                fit: BoxFit.cover,
                              )
                            ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ReusableWidgets.buildButton('Camera', () {
                              pickImageCamera();
                            }),
                            ReusableWidgets.buildButton('Galleria', () {
                              pickImageGallery();
                            }),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 24),

                    ReusableWidgets.buildButton('Modifica', () {
                      if (nameProductController.text.isEmpty ||
                          restaurantNameController.text.isEmpty ||
                          restaurantAddressController.text.isEmpty ||
                          quantityController.text.isEmpty ||
                          dateController.text.isEmpty ||
                          selectedButtonCategory.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Errore'),
                                content: const Text('Inserisci tutti i campi'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Ok')),
                                ],
                              );
                            });
                        return;
                      } else {
                        final food = Food(
                          nameProduct:  nameProductController.text.capitalize(),
                          restaurantName: restaurantNameController.text.capitalize(),
                          restaurantAddress: restaurantAddressController.text.capitalize(),
                          quantity: int.parse(quantityController.text),
                          date: DateFormat('yyyy-MM-dd')
                              .parse(dateController.text),
                          category: selectedButtonCategory,
                          userId: '',
                        );
                        updateFood(food);

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
}
