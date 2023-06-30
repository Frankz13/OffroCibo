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
      backgroundColor: Colors.white,
      body: const SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: Text(
                  "Bentornato! Le tue offerte:",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              CardOfferta(),
              CardOfferta(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
      floatingActionButton: ClipOval(
        child: FloatingActionButton(
          onPressed: (){Navigator.pushNamed(context, '/login');},
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
