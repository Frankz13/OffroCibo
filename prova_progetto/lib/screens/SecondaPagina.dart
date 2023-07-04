import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prova_progetto/widgets/cards/widget_card.dart';
import 'package:prova_progetto/widgets/BottomNavBar.dart';

class User {
  String id;
  final String name;
  final int age;
  final DateTime birthday;

  User({
    this.id = '',
    required this.name,
    required this.age,
    required this.birthday,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'age': age,
    'birthday': birthday,
  };
}

class SecondaPagina extends StatefulWidget {
  const SecondaPagina({super.key});

  @override
  State<SecondaPagina> createState() => _SecondaPaginaState();
}

class _SecondaPaginaState extends State<SecondaPagina> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(controller: controller),
        actions: [
          IconButton(
            onPressed: () {
              final name = controller.text;
              createUser(name: name);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      // Rest of your code...
    );
  }

  Future createUser({required String name}) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();

    final user = User(
      id: docUser.id,
      name: name,
      age: 21,
      birthday: DateTime(2003, 08, 12),
    );
    final json = user.toJson();
    await docUser.set(json);
  }
}
