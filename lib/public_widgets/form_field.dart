import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String hint;
  final IconData? icon;
  final bool readOnly;
  final int? maxLines;
  final bool obscureText;
  final TextInputType keyboardType;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.title,
    required this.hint,
    this.icon,
    this.readOnly = false,
    this.maxLines,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          maxLines: maxLines,
          readOnly: readOnly || onTap != null,
          focusNode: readOnly ? AlwaysDisabledFocusNode() : null,
          keyboardType: keyboardType,
          onTap: onTap,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon, color: primaryBlue) : null,
            filled: true,
            fillColor: primaryBlue.withOpacity(0.04),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
