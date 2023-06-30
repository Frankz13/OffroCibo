import 'package:flutter/material.dart';
import 'package:prova_progetto/widgets/cards/widget_card.dart';
import 'package:prova_progetto/widgets/BottomNavBar.dart';

class SecondaPagina extends StatefulWidget {
  const SecondaPagina({super.key});

  @override
  State<SecondaPagina> createState() => _SecondaPaginaState();
}

class _SecondaPaginaState extends State<SecondaPagina> {
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
              CardOfferta(),
              CardOfferta(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButton: ClipOval(
        child: FloatingActionButton(
          onPressed: (){},
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}