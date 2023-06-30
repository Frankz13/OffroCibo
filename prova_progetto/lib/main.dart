import 'package:flutter/material.dart';
import 'package:prova_progetto/screens/Login.dart';
import 'package:prova_progetto/screens/Registrazione.dart';

import 'package:prova_progetto/screens/PrimaPagina.dart';
import 'package:prova_progetto/screens/SecondaPagina.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OffroCibo_offerte',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        brightness: Brightness.light,

        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(title: 'OffroCibo_offerte'),
      routes: {
        '/prima': (context) => PrimapPagina(),
        '/seconda': (context) => SecondaPagina(),
        '/registrazione' : (context) => Registrazione(),
        '/login' : (context) => LoginPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return const Registrazione();
  }
}
