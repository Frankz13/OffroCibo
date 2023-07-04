import 'package:flutter/material.dart';

class ReusableWidgets {

  static Widget buildTextField(String hint,{bool isPassword = false}) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
  obscureText: isPassword,
    );
  }

  static Widget buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(color: Colors.white)),  // Questo cambia il colore del testo
    );
  }

}
