import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prova_progetto/widgets/ReausableWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';


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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 600,
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
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: Text("Aggiungi un'offerta",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                      )
                      ),
                    ),
                    ReusableWidgets.buildTextField('Nome del prodotto:',
                        controller: controllerNameProduct),
                    const SizedBox(height: 16),
                    ReusableWidgets.buildTextField('Nome Ristorante:',
                        controller: controllerRestaurantName),
                    const SizedBox(height: 16),
                    ReusableWidgets.buildTextField('Indirizzo Ristorante',
                        controller: controllerRestaurantAddress),
                    const SizedBox(height: 16),
                    ReusableWidgets.buildTextField('Numero porzioni',
                        controller: controllerQuantity,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 16),
                    ReusableWidgets.buildDateTimeField(
                        controller: controllerDate,
                        hint: "Data di produzione"),
                    const SizedBox(height: 24),
                ReusableWidgets.buildButton('Create', () {
                  final food = Food(
                    nameProduct: controllerNameProduct.text,
                    quantity: int.parse(controllerQuantity.text),
                    date: DateFormat('yyyy-MM-dd').parse(controllerDate.text),
                    restaurantName: controllerRestaurantName.text,
                    restaurantAddress: controllerRestaurantAddress.text,
                    userId: '',
                  );
                  createFood(food);
                  Navigator.pop(context);
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


    final json = food.toJson();
    await docFood.set(json);
  }
}

class Food {
  String? userId;
  final String nameProduct;
  final int quantity;
  final DateTime date;
  final String restaurantName;
  final String restaurantAddress;

  Food({
  required this.nameProduct,
  required this.quantity,
  required this.date,
  required this.restaurantName,
    required this.restaurantAddress,
    required this.userId,

  });

  Map<String, dynamic> toJson() {
    return {

      'name_product': nameProduct,
      'quantity': quantity,
      'date': date,
      'restaurant_name': restaurantName,
      'restaurant_address': restaurantAddress,
      'user_id': userId,
    };
  }
}


