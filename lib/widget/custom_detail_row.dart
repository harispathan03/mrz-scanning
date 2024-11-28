import 'package:flutter/material.dart';

class CustomDetailRow extends StatelessWidget {
  final String propertyName;
  final String value;
  const CustomDetailRow(
      {super.key, required this.propertyName, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          propertyName,
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ],
    );
  }
}
