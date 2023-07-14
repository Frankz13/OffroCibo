import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GetFoodName extends StatelessWidget {

  final String documentId;
  

  const GetFoodName({required this.documentId});

  @override
  Widget build(BuildContext context) {

    CollectionReference foods = FirebaseFirestore.instance
        .collection('food');

    return StreamBuilder<DocumentSnapshot>(
        stream: foods.doc(documentId).snapshots(),
        builder: (context, snapshot){

          if (snapshot.connectionState == ConnectionState.active){
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

  const GetRestaurantName({required this.documentId});

  @override
  Widget build(BuildContext context) {

    CollectionReference foods = FirebaseFirestore.instance
        .collection('food');

    return StreamBuilder<DocumentSnapshot>(
        stream: foods.doc(documentId).snapshots(),
        builder: (context, snapshot){

          if (snapshot.connectionState == ConnectionState.active){
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

  const GetRestaurantAddress({required this.documentId});

  @override
  Widget build(BuildContext context) {

    CollectionReference foods = FirebaseFirestore.instance
        .collection('food');

    return StreamBuilder<DocumentSnapshot>(
        stream: foods.doc(documentId).snapshots(),
        builder: (context, snapshot){

          if (snapshot.connectionState == ConnectionState.active){
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

  const GetFoodQuantity({required this.documentId});

  @override
  Widget build(BuildContext context) {

    CollectionReference foods = FirebaseFirestore.instance
        .collection('food');

    return StreamBuilder<DocumentSnapshot>(
        stream: foods.doc(documentId).snapshots(),
        builder: (context, snapshot){

          if (snapshot.connectionState == ConnectionState.active){
            var data = snapshot.data!.data() as Map<String, dynamic>;
            // DateTime date = (data['date'] as Timestamp).toDate();

            return Text(
              '${data['quantity']}',
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

class GetFoodDate extends StatelessWidget {

  final String documentId;

  const GetFoodDate({required this.documentId});

  @override
  Widget build(BuildContext context) {

    CollectionReference foods = FirebaseFirestore.instance
        .collection('food');

    return StreamBuilder<DocumentSnapshot>(
        stream: foods.doc(documentId).snapshots(),
        builder: (context, snapshot){

          if (snapshot.connectionState == ConnectionState.active){
            var data = snapshot.data!.data() as Map<String, dynamic>;
            DateTime date = (data['date'] as Timestamp).toDate();

            return Text('Prodotto il: ${DateFormat('dd/MM/yyyy').format(date)}',
            );
          }
          return const Text('loading...');
        });
  }
}

class GetCategory extends StatelessWidget {

  final String documentId;

  const GetCategory({required this.documentId});

  @override
  Widget build(BuildContext context) {

    CollectionReference foods = FirebaseFirestore.instance
        .collection('food');

    return StreamBuilder<DocumentSnapshot>(
        stream: foods.doc(documentId).snapshots(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.active){
            var data = snapshot.data!.data() as Map<String, dynamic>;
            // DateTime date = (data['date'] as Timestamp).toDate();
            return Text('${data['category']}',
              style: const TextStyle(
                color: Colors.green,
                fontSize: 15,
                fontWeight: FontWeight.bold,


              ),
            );
          }
          return const Text('loading...');
        });
  }
}
