import 'package:flutter/material.dart';

InputDecoration appInputDecoration({
  String? label,
  double radius = 10,
  String? hint,
  IconData? prefixIcon,
  Widget? suffixIcon,
  Color? fillColor,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    filled: true,
    fillColor: fillColor ?? Colors.grey.shade100,
    prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
    suffixIcon: suffixIcon,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide.none,
    ),
  );
}
