import 'package:flutter/material.dart';

import '../theme/color_theme.dart';

class BtnApp extends StatelessWidget {
  const BtnApp({
    super.key,
    this.title,
  });
  final String? title;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: pinkColorOpacit5,
        ),
        child: Text(
          title ?? "INICIAR SESIÒN",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
