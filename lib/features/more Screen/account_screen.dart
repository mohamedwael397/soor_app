import 'package:flutter/material.dart';
import 'package:soor_app/core/const/constans.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        backgroundColor: AppTheme.fieldBackground,
        elevation: 0,
        centerTitle: true,

        leading: Material(
          color: Colors.transparent,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppTheme.fieldBorder,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.hintColor),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ),

        title: const Text(
          'الحساب',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: Form(
          key: formKey,

          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // رقم الجوال
                AccountField(
                  label: 'رقم الجوال',
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  hint: "+966 000 000 00",

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'من فضلك أدخل رقم الجوال';
                    }

                    if (value.trim().length < 10) {
                      return 'رقم الجوال غير صحيح';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 22),

                // البريد الإلكتروني
                AccountField(
                  label: 'البريد الإلكتروني',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  hint: "info@gmail.com",

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'من فضلك أدخل البريد الإلكتروني';
                    }

                    final emailRegex = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    );

                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'البريد الإلكتروني غير صحيح';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 22),

                // الاسم
                AccountField(
                  label: 'الاسم الكامل',
                  controller: nameController,
                  hint: "احمد محمد",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'من فضلك أدخل الاسم الكامل';
                    }

                    if (value.trim().length < 3) {
                      return 'الاسم يجب أن يكون 3 أحرف على الأقل';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 22),

                // كلمة المرور
                AccountField(
                  label: 'كلمة المرور',
                  controller: passwordController,
                  obscureText: true,
                  hint: "*********",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'من فضلك أدخل كلمة المرور';
                    }

                    if (value.length < 6) {
                      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 22),

                // تأكيد كلمة المرور
                AccountField(
                  label: 'تأكيد كلمة المرور',
                  controller: confirmPasswordController,
                  obscureText: true,

                  hint: "*********",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'من فضلك أكد كلمة المرور';
                    }

                    if (value != passwordController.text) {
                      return 'كلمة المرور غير متطابقة';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

///
/// Account Field
///
class AccountField extends StatelessWidget {
  const AccountField({
    super.key,
    required this.label,
    required this.hint,

    required this.controller,
    required this.validator,
    this.obscureText = false,
    this.keyboardType,
  });

  final String label;
  final String hint;

  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;

  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 10),

          child: Text(
            label,

            style: const TextStyle(color: Color(0xFFB8B8BE), fontSize: 14),
          ),
        ),

        TextFormField(
          controller: controller,

          validator: validator,

          obscureText: obscureText,

          keyboardType: keyboardType,

          textAlign: TextAlign.right,

          style: const TextStyle(color: Color(0xFF8B8B92), fontSize: 15),

          decoration: InputDecoration(
            filled: true,
            hintText: hint,

            fillColor: AppTheme.fieldBackground,

            isDense: true,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),

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
              borderSide: const BorderSide(color: Color(0xFF3A3A40)),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red),
            ),

            errorStyle: const TextStyle(color: Colors.red, fontSize: 12),

            suffixIcon: const Padding(
              padding: EdgeInsets.only(left: 4),

              child: Icon(Icons.edit_outlined, color: Colors.white, size: 18),
            ),

            suffixIconConstraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 0,
            ),
          ),
        ),
      ],
    );
  }
}
