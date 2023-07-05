import 'package:flutter/material.dart';
import 'package:prova_progetto/screens/PrimaPagina.dart';
import 'package:prova_progetto/screens/SecondaPagina.dart';
import 'package:prova_progetto/screens/UserPage.dart';
class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      child: SizedBox(
        height: 60.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PrimapPagina()));},
              icon: const Icon(Icons.food_bank),
              color: Colors.deepPurple,
            ),
            IconButton(
              onPressed: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UserPage()));},
              icon: const Icon(Icons.person),
              color: Colors.deepPurple,
            ),
          ],
        ),
      ),
    );

  }
}
