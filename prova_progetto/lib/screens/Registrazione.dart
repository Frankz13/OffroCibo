import 'package:flutter/material.dart';
import 'package:prova_progetto/screens/Login.dart';
import 'package:prova_progetto/screens/PrimaPagina.dart';
import 'package:prova_progetto/widgets/ReausableWidgets.dart';
import 'package:prova_progetto/widgets/form.dart';

class Registrazione extends StatefulWidget {
  const Registrazione({super.key});


  @override
  State<Registrazione> createState() => _RegistrazioneState();
}


class _RegistrazioneState extends State<Registrazione> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:
      Container(
        decoration: const BoxDecoration(

            image: DecorationImage(
              image: AssetImage('images/fresh.jpg'),
              fit: BoxFit.cover,
            )
        ),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 700,
                maxWidth: 350,
              ),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text("Benvenuto!",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const Text("Registrati per iniziare",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [RegistrationForm()]
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Row(
                      //   children: [
                      //     Expanded(child: ReusableWidgets.buildButton("REGISTRATI", () {
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(builder: (context) => PrimapPagina())
                      //       );})),
                      //   ],
                      // ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Text("Hai già un account?"),
                          ReusableWidgets.buildButton("Login", () {Navigator.pop(context);}),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
