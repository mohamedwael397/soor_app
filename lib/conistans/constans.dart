import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color(0xff9E6A00);
  static const fieldBackground = Color(0xFF1C1C1E);
  static const fieldBorder = Color(0xFF2A2A2C);
  static const labelColor = Colors.white;
  static const hintColor = Color(0xFF8A8A8E);
}

typedef MyValidator = String? Function(String?);

class TextFormFieldWidget extends StatefulWidget {
  final TextInputType keyboardType;
  final String? hintText;
  final String? label;
  final int? maxLines;
  final int? maxLength;

  final bool obscureText;
  final bool isPassword;

  final TextEditingController controller;
  final MyValidator? validator;

  final Widget? prefixIcon;

  final TextDirection textDirection;
  final TextAlign textAlign;

  const TextFormFieldWidget({
    super.key,
    required this.controller,
    required this.validator,
    required this.hintText,
    required this.label,

    this.prefixIcon,
    this.maxLines,
    this.maxLength,

    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.isPassword = false,

    this.textDirection = TextDirection.rtl,
    this.textAlign = TextAlign.right,
  });

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8, right: 2, left: 2),
            child: Text(
              widget.label!,
              textAlign: widget.textAlign,
              textDirection: widget.textDirection,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.labelColor,
              ),
            ),
          ),

        TextFormField(
          controller: widget.controller,
          validator: widget.validator,

          maxLines: widget.isPassword ? 1 : widget.maxLines,

          maxLength: widget.maxLength,

          obscureText: widget.isPassword ? _obscure : false,

          keyboardType: widget.keyboardType,

          textAlign: widget.textAlign,
          textDirection: widget.textDirection,

          autovalidateMode: AutovalidateMode.onUserInteraction,

          cursorColor: AppTheme.primaryColor,

          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            overflow: TextOverflow.ellipsis,
          ),

          decoration: InputDecoration(
            filled: true,
            fillColor: AppTheme.fieldBackground,

            hintText: widget.hintText,

            hintStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.hintColor,
              overflow: TextOverflow.ellipsis,
            ),

            counterText: '',

            prefixIcon: widget.prefixIcon,

            // 👁️ عين الباسورد
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      color: AppTheme.hintColor,
                      size: 22,
                    ),
                  )
                : null,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),

            border: _border(AppTheme.fieldBorder),
            enabledBorder: _border(AppTheme.fieldBorder),
            focusedBorder: _border(AppTheme.primaryColor),
            errorBorder: _border(Colors.redAccent),
            focusedErrorBorder: _border(Colors.redAccent),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: 1),
    );
  }
}
