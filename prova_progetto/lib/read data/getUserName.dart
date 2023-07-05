import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GetUserName extends StatelessWidget {

  final String documentId;

  GetUserName({required this.documentId});

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

            return Text(
              '${data['name_product']} ${data['restaurant_address']} ${data['restaurant_name']} ${DateFormat('dd/MM/yyyy').format(date)} ${data['quantity']}',
            );
          }
          return const Text('loading...');
        });
  }
}
