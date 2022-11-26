import 'package:flutter/material.dart';

class GetTextField extends StatelessWidget {
  TextInputType keytype;
  TextEditingController Controller;
  String hintname;
  IconData icon;
  bool isObsecureText;
  String label;

  GetTextField(
      {Key? key,
      required this.keytype,
      required this.Controller,
      required this.hintname,
      required this.icon,
      required this.isObsecureText,
      required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        obscureText: isObsecureText,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter The Details";
          } else {
            return null;
          }
        },
        controller: Controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.teal)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.amber),
          ),
          prefixIcon: Icon(icon),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: hintname,
          labelText: label,
          fillColor: Colors.grey[300],
          filled: true,
        ),
        keyboardType: keytype,
      ),
    );
  }
}
