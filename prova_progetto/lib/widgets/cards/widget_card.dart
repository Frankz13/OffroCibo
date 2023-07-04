import 'package:flutter/material.dart';

class CardOfferta extends StatefulWidget {
  const CardOfferta({Key? key}) : super(key: key);

  @override
  _CardOffertaState createState() => _CardOffertaState();
}

class _CardOffertaState extends State<CardOfferta> {
  bool isFavourite = false;


  void _liked() {
    setState(() {
      isFavourite = !isFavourite;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                const Text(
                  "Pizza Margherita",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                const Text("porzioni: 0"),
                const Text(
                  "Nome della pizzeria",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text("indirizzo della pizzeria"),
                const Text("scadenza 01/01/2024"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _liked();
                      },
                      child: isFavourite
                          ? const Icon(Icons.mode, color: Colors.red)
                          : const Icon(Icons.mode_edit_outline_outlined),
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
  }
}
