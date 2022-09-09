import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  TextFieldContainer({Key? key, required this.label,required this.icon, required this.callback, this.iController, this.aValidateMode, this.validation}) : super(key: key);
  final String label;
  final IconData icon;
  final bool callback;
  final TextEditingController? iController;
  final aValidateMode;
  final validation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: iController,
        obscureText: callback,
        autovalidateMode: aValidateMode,
        validator: validation,
        decoration: InputDecoration(
          suffixIcon: Icon(icon),
          border: InputBorder.none,
          hintText: label,
          // label: Container(
          //   margin: const EdgeInsets.only(left: 10,),
          //   child: Text(label, style: const TextStyle(color: Colors.grey),),)
        ),
      ),
    );
  }
}