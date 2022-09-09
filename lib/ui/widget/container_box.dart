import 'package:firebase/ui/widget/text_field.dart';
import 'package:flutter/material.dart';

class ContainerBox extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final bool kCallBack;
  final TextEditingController? controller;
  final kValidateMode;
  final kValidation;

  ContainerBox(
      {super.key,
      required this.labelText,
      required this.icon,
      required this.kCallBack,
      this.controller,
      this.kValidateMode,
      this.kValidation});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextFieldContainer(
          label: labelText,
          icon: icon,
          callback: kCallBack,
          iController: controller,
          aValidateMode: kValidateMode,
          validation: kValidation,
        ));
  }
}
