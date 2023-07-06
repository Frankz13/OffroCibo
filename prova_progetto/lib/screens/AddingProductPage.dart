import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:prova_progetto/widgets/ReausableWidgets.dart';


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

  InputDecoration decoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: 600,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.white,
            elevation: 50,
            shadowColor: Colors.black,
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
    );

  }

  // Widget buildFood(Food food) => ListTile(
  //   leading: CircleAvatar(
  //     child: Text('${food.date}'),
  //   ),
  //   title: Text(food.nameProduct),
  //   subtitle: Text(food.date.toIso8601String()),
  // );

  // Stream<List<Food>> readFoods() => FirebaseFirestore.instance
  //     .collection('food')
  //     .snapshots()
  //     .map((snapshot) => snapshot.docs.map((doc) => Food.fromJson(doc.data())).toList());

  Future<void> createFood(Food food) async {
    final docFood = FirebaseFirestore.instance.collection('food').doc();
    food.id = docFood.id;

    final json = food.toJson();
    await docFood.set(json);
  }
}

class Food {
  late String id;
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
    this.id = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_product': nameProduct,
      'quantity': quantity,
      'date': date,
      'restaurant_name': restaurantName,
      'restaurant_address': restaurantAddress,
    };
  }

  // static Food fromJson(Map<String, dynamic> json) => Food(
  //   id: json['id'],
  //   nameProduct: json['name_product'],
  //   quantity: json['quantity'],
  //   date: (json['date'] as Timestamp).toDate(),
  //   restaurantName: json['restaurant_name'],
  //   restaurantAddress: json['restaurant_address'],
  // );
}


