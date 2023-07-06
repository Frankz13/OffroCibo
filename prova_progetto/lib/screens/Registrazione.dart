import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
                maxHeight: 750,
                maxWidth: 350,
              ),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Benvenuto!",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const Text("Registrati per iniziare",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [RegistrationForm()]
                        ),
                      ),

                      const SizedBox(height:8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black),
                              text: 'Hai già un account? ',
                              children: [
                                TextSpan(
                                  text: 'Log in',
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.green
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(context, '/login');
                                    },
                                ),
                              ],
                            ),
                          ),
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
