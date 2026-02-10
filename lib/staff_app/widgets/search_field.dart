import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final TextStyle hintStyle;
  final Color textColor;
  final Color iconColor;

  const SearchField({
    super.key,
    required this.hint,
    this.onChanged,
    required this.hintStyle,
    required this.textColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,

      // ✅ TEXT COLOR (white in dark theme)
      style: TextStyle(
        color: textColor,
        fontSize: 16,
      ),

      decoration: InputDecoration(
        // ✅ ICON COLOR
        prefixIcon: Icon(
          Icons.search,
          color: iconColor,
        ),

        hintText: hint,

        // ✅ HINT COLOR
        hintStyle: hintStyle,

        filled: true,

        // IMPORTANT: keep fill transparent, parent container controls color
        fillColor: Colors.transparent,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),

        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
      ),
    );
  }
}
