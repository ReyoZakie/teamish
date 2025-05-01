import 'package:flutter/material.dart';

class CostumeFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController myController;
  final String? Function(String?)? validator;// this is used to make sure the field is not empty 

  const CostumeFormField(
      {super.key, required this.hintText, required this.myController, required this.validator});
  
  

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: myController,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(255, 27, 4, 42),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
        hintText: hintText,
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
