import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color(0xff9E6A00);
  static const background = Color(0xff0D0D0D);
  static const fieldBackground = Color(0xFF1C1C1E);
  static const fieldBorder = Color(0xFF2A2A2C);
  static const labelColor = Colors.white;
  static const hintColor = Color(0xFF8A8A8E);
}

class CustomCircleButton extends StatelessWidget {
  final IconData icon;
  final Gradient backgroundColor;
  final String text;
  final VoidCallback? onTap;

  const CustomCircleButton({
    super.key,
    required this.icon,
    required this.backgroundColor,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: backgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 38),

              const SizedBox(height: 5),

              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppColors {
  static const Color white = Color(0xffFFFFFF);
  static const Color black = Color(0xff000000);

  static const Color darkBg = Color(0xff0D0D0D);
  static const Color appBarBg = Color(0xff141414);
  static const Color inputBg = Color(0xff212121);
  static const Color inputBorder = Color(0xff2E2E2E);
  static const Color textMuted = Color(0xff878787);
  static const Color textSoft = Color(0xffD0D5DD);
  static const Color gold = Color(0xffC89100);
  static const Color goldDark = Color(0xff9E6A00);
  static const Color indicator = Color(0xff474747);
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
