import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GetFoodName extends StatelessWidget {

  final String documentId;

  GetFoodName({required this.documentId});

  @override
  Widget build(BuildContext context) {

    CollectionReference users = FirebaseFirestore.instance
        .collection('food');

    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(documentId).get(),
        builder: (context, snapshot){

          if (snapshot.connectionState == ConnectionState.done){
            var data = snapshot.data!.data() as Map<String, dynamic>;
            // DateTime date = (data['date'] as Timestamp).toDate();

            return Text(
              '${data['name_product']}',
                style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
            );
          }
          return const Text('loading...');
        });
  }
}

class GetRestaurantName extends StatelessWidget {

  final String documentId;

  GetRestaurantName({required this.documentId});

  @override
  Widget build(BuildContext context) {

    CollectionReference users = FirebaseFirestore.instance
        .collection('food');

    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(documentId).get(),
        builder: (context, snapshot){

          if (snapshot.connectionState == ConnectionState.done){
            var data = snapshot.data!.data() as Map<String, dynamic>;
            // DateTime date = (data['date'] as Timestamp).toDate();

            return Text(
              '${data['restaurant_name']}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            );
          }
          return const Text('loading...');
        });
  }
}

class GetRestaurantAddress extends StatelessWidget {

  final String documentId;

  GetRestaurantAddress({required this.documentId});

  @override
  Widget build(BuildContext context) {

    CollectionReference users = FirebaseFirestore.instance
        .collection('food');

    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(documentId).get(),
        builder: (context, snapshot){

          if (snapshot.connectionState == ConnectionState.done){
            var data = snapshot.data!.data() as Map<String, dynamic>;
            // DateTime date = (data['date'] as Timestamp).toDate();

            return Text(
              '${data['restaurant_address']}',
              style: const TextStyle(
                fontSize: 15,

              ),
            );
          }
          return const Text('loading...');
        });
  }
}

class GetFoodQuantity extends StatelessWidget {

  final String documentId;

  GetFoodQuantity({required this.documentId});

  @override
  Widget build(BuildContext context) {

    CollectionReference users = FirebaseFirestore.instance
        .collection('food');

    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(documentId).get(),
        builder: (context, snapshot){

          if (snapshot.connectionState == ConnectionState.done){
            var data = snapshot.data!.data() as Map<String, dynamic>;
            // DateTime date = (data['date'] as Timestamp).toDate();

            return Text(
              'Quantità: ${data['quantity']}',
              style: const TextStyle(
                fontSize: 15,
              ),
            );
          }
          return const Text('loading...');
        });
  }
}

class GetFoodDate extends StatelessWidget {

  final String documentId;

  GetFoodDate({required this.documentId});

  @override
  Widget build(BuildContext context) {

    CollectionReference users = FirebaseFirestore.instance
        .collection('food');

    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(documentId).get(),
        builder: (context, snapshot){

          if (snapshot.connectionState == ConnectionState.done){
            var data = snapshot.data!.data() as Map<String, dynamic>;
            DateTime date = (data['date'] as Timestamp).toDate();

            return Text('Prodotto il: ${DateFormat('dd/MM/yyyy').format(date)}',
            );
          }
          return const Text('loading...');
        });
  }
}
