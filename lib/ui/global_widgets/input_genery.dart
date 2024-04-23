import 'package:flutter/material.dart';

import '../theme/color_theme.dart';

class InputGenery extends StatelessWidget {
  const InputGenery({
    super.key,
    this.prefixIcon,
    this.hintText,
    this.suffix,
  });

  final Widget? prefixIcon;
  final String? hintText;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: pinkColorOpacit5,
          ),
        ),
        prefixIcon: prefixIcon ?? const Icon(Icons.email_outlined),
        hintText: hintText ?? "Correo",
        suffixIcon: suffix,
      ),
    );
  }
}
