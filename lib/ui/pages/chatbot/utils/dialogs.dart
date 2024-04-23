import 'package:flutter/material.dart';

showdialogError(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      children: [
        const Text("algo salio mal, intente nuevamente"),
        const SizedBox(
          height: 15,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Ok"),
        ),
      ],
    ),
  );
}
