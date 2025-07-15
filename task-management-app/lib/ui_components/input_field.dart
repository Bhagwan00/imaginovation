import 'package:flutter/material.dart';

import '../config/input_styles.dart';

class InputField extends StatelessWidget {
  final String? label;
  final String hint;
  final bool isObscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Function? validator;
  final int lines;

  const InputField({
    super.key,
    this.label,
    this.hint = '',
    this.isObscureText = false,
    this.controller,
    this.lines = 1,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscureText,
      keyboardType: keyboardType,
      maxLines: lines,
      decoration: kInputSecondaryStyle.copyWith(
        hintText: hint,
      ),
      validator: validator as String? Function(String?)?,
    );
  }
}
