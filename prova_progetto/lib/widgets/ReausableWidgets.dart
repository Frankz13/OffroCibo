import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReusableWidgets {

  static Widget buildTextField(String hint,
      {TextEditingController? controller, TextInputType? keyboardType, bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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

  static InputDecoration buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }


  static Widget buildDateTimeField({required TextEditingController controller, required String hint}) {
    return DateTimeField(
      controller: controller,
      format: DateFormat('yyyy-MM-dd'),
      decoration: buildInputDecoration(hint),
      onShowPicker: (context, currentValue) async {
        final date = await showDatePicker(
          context: context,
          firstDate: DateTime(1900),
          initialDate: currentValue ?? DateTime.now(),
          lastDate: DateTime.now(),
        );
        return date;
      },
    );
  }




}
