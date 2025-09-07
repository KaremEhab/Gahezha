import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:iconly/iconly.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final String hint;
  final IconData? icon;
  final bool readOnly;
  final int? maxLines;
  final bool obscureText; // initial value
  final TextInputType keyboardType;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.title,
    required this.hint,
    this.icon,
    this.readOnly = false,
    this.maxLines = 1,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onTap,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool isObscure;

  @override
  void initState() {
    super.initState();
    isObscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title.isNotEmpty) ...[
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          obscureText: isObscure,
          maxLines: widget.maxLines,
          readOnly: widget.readOnly || widget.onTap != null,
          focusNode: widget.readOnly ? AlwaysDisabledFocusNode() : null,
          keyboardType: widget.keyboardType,
          onTap: widget.onTap,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.icon != null
                ? Icon(widget.icon, color: Colors.black87)
                : null,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      isObscure ? IconlyLight.show : IconlyLight.hide,
                      color: Colors.black87,
                    ),
                    onPressed: () => setState(() => isObscure = !isObscure),
                  )
                : null,
            filled: true,
            fillColor: Colors.grey.shade100,
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
