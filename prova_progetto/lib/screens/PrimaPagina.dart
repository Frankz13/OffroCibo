import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prova_progetto/screens/Registrazione.dart';
import 'package:prova_progetto/widgets/cards/widget_card.dart';
import 'package:prova_progetto/widgets/BottomNavBar.dart';

class PrimapPagina extends StatefulWidget {
  const PrimapPagina({Key? key}) : super(key: key);

  @override
  _PrimapPaginaState createState() {
    return _PrimapPaginaState();
  }
}

class _PrimapPaginaState extends State<PrimapPagina> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(
      "Bentornato! Le tue offerte:",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: (){
            FirebaseAuth.instance.signOut();}, icon: const Icon(Icons.logout),),
            ],
            ),
            backgroundColor: Colors.white,
            body: const SingleChildScrollView(
            child: Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

            CardOfferta(),
            CardOfferta(),
            ],
            ),
            ),
            ),
            bottomNavigationBar: const BottomNavBar(),
            floatingActionButton: ClipOval(
            child: FloatingActionButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            child: const Icon(Icons.sign_language_outlined)
            ,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
