import 'package:flutter/material.dart';
import 'package:prova_progetto/screens/PrimaPagina.dart';
import 'package:prova_progetto/screens/Registrazione.dart';
import 'package:prova_progetto/widgets/ReausableWidgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                maxHeight: 500,
                maxWidth: 350,
              ),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text("Bentornato!",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const Text("Effettua l'acceso per iniziare",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReusableWidgets.buildTextField('Email'),
                            const SizedBox(height: 20),
                            ReusableWidgets.buildTextField('Password', isPassword: true),
                            const Text("Hai dimenticato la password?", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(child: ReusableWidgets.buildButton("LOGIN", () {
                            Navigator.push(
                                context,
                            MaterialPageRoute(builder: (context) => PrimapPagina())
                            );
                          })
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Text("Non hai un account?"),
                          ReusableWidgets.buildButton("Registrati", () {Navigator.pushNamed(context, '/registrazione');}),
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
