import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prova_progetto/screens/RestaurantPage.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String firstName = _firstNameController.text;
      String lastName = _lastNameController.text;
      String password = _passwordController.text.trim();

      FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)
          .then((userCredential) async {
        String firebaseAuthUserId = userCredential.user!.uid;
        await addUserDetails(firstName, lastName, email, firebaseAuthUserId);
        Navigator.pushReplacement(context, PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => const RestaurantPage(),
        ));
      })
          .catchError((error) {
        print("Error creating user: $error");
      });
    }
  }

  Future<void> addUserDetails(
      String firstName,
      String lastName,
      String email,
      String firebaseAuthUserId) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'food_quantity': 0,
      'firebase_auth_user_id': firebaseAuthUserId,
    });
  }




  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              labelText: 'Email',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter an email';
              }

              String emailPattern = r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)*(\.[a-zA-Z]{2,})$';
              RegExp regExp = RegExp(emailPattern);

              if(!regExp.hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),

          TextFormField(
            controller: _firstNameController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              ),

              labelText: 'Nome',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter first name';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _lastNameController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              labelText: 'Cognome',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a last name';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: 'Password',
            ),
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a password';
              }

              // Controllo per almeno 8 caratteri
              if (value.length < 8) {
                return 'Must be at least 8 characters long';
              }

              // Controllo per almeno un carattere speciale
              String specialCharPattern = r'(?=.*[@#$%^&+=!])';
              RegExp specialCharRegExp = RegExp(specialCharPattern);
              if (!specialCharRegExp.hasMatch(value)) {
                return 'Must contain at least one special character';
              }

              // Controllo per almeno un numero
              String numberPattern = r'(?=.*[0-9])';
              RegExp numberRegExp = RegExp(numberPattern);
              if (!numberRegExp.hasMatch(value)) {
                return 'Must contain at least one number';
              }

              return null;
            },
          ),

          const SizedBox(height: 8),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              labelText: 'Conferma Password',
            ),
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please confirm the password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                  onPressed: _submitForm,
                  child: const Text('Registrati'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
