import 'package:flutter/material.dart';

import '../config/colors.dart';
import '../config/input_styles.dart';

class InputFieldLabel extends StatelessWidget {
  final String label;
  final String hint;
  final bool isObscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Function? validator;
  final Function? onChanged;
  final Function? onTap;
  final int lines;
  final bool isFullBorder;
  final Color color;
  final bool readonly;

  const InputFieldLabel({
    super.key,
    required this.label,
    this.hint = '',
    this.isObscureText = false,
    this.readonly = false,
    this.controller,
    this.lines = 1,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onTap,
    this.isFullBorder = true,
    this.color = kWhiteColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
        ),
        TextFormField(
          controller: controller,
          obscureText: isObscureText,
          cursorColor: Colors.black,
          keyboardType: keyboardType,
          readOnly: readonly,
          onTap: () => onTap?.call(),
          onChanged: onChanged as String? Function(String?)?,
          maxLines: lines,
          decoration: kInputSecondaryStyle.copyWith(
            hintText: hint,
          ),
          validator: validator as String? Function(String?)?,
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
