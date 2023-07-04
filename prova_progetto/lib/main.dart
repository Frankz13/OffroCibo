import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prova_progetto/screens/Login.dart';
import 'package:prova_progetto/screens/Registrazione.dart';
import 'package:prova_progetto/screens/PrimaPagina.dart';
import 'package:prova_progetto/screens/SecondaPagina.dart';
import 'package:prova_progetto/screens/UserPage.dart';
import 'package:prova_progetto/widgets/form.dart';
import 'package:prova_progetto/widgets/FormLogin.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OffroCibo',
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
        '/userPage' : (context) => UserPage(),
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
    return const LoginPage();
  }
}
