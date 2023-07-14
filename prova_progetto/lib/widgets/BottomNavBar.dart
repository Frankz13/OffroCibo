import 'package:flutter/material.dart';
import 'package:prova_progetto/screens/RestaurantPage.dart';
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
            // IconButton(
            //   onPressed: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PrimapPagina()));},
            //   icon: const Icon(Icons.food_bank),
            //   color: Colors.deepPurple,
            // ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => const RestaurantPage(),
                  transitionDuration: const Duration(seconds: 1),
                  transitionsBuilder: (context, animation, animationTime, child) {
                    animation = CurvedAnimation(parent: animation, curve: Curves.easeIn);
                    return SlideTransition(
                      position: Tween(begin: const Offset(-1.0, 0.0), end: const Offset(0.0, 0.0)).animate(animation),
                      child: child,
                    );
                  },
                ));
              },
              icon: const Icon(Icons.food_bank),
              color: Colors.deepPurple,
            ),

            IconButton(
              onPressed: () {
                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => const UserPage(),
                  transitionDuration: const Duration(milliseconds: 700),
                  transitionsBuilder: (context, animation, animationTime, child) {
                    animation = CurvedAnimation(parent: animation, curve: Curves.easeIn);
                    return SlideTransition(
                      position: Tween(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0)).animate(animation),
                      child: child,
                    );
                  },
                ));
              },
              icon: const Icon(Icons.person),
              color: Colors.deepPurple,
            )

          ],
        ),
      ),
    );

  }
}
