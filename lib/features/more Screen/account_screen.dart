import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soor_app/core/const/constans.dart';
import 'package:soor_app/core/utils/storage_helper.dart';
import 'package:soor_app/core/utils/validators.dart';
import 'package:soor_app/features/auth/logic/auth_cubit.dart';
import 'package:soor_app/features/auth/logic/auth_state.dart';

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
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = StorageHelper.getUser();
    nameController.text = user?.name ?? '';
    phoneController.text = user?.phone ?? StorageHelper.getPhone() ?? '';
    emailController.text = user?.email ?? '';
    // جيب أحدث بيانات من السيرفر
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().fetchProfile();
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _save() {
    if (!formKey.currentState!.validate()) return;
    final pass = passwordController.text.trim();
    final confirm = confirmPasswordController.text.trim();
    // لو الباسورد فاضي يبقى مش هنحدثه
    context.read<AuthCubit>().updateProfile(
          name: nameController.text.trim(),
          phone: phoneController.text.trim(),
          email: emailController.text.trim(),
          password: pass.isEmpty ? null : pass,
          confirmPassword: confirm.isEmpty ? null : confirm,
        );
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
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
            ),
          ),
        ),
        title: const Text('الحساب',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            // حدث الحقول لما البروفايل يجي من السيرفر (مرة واحدة)
            if (nameController.text.isEmpty && state.name.isNotEmpty) {
              nameController.text = state.name;
            }
            if (phoneController.text.isEmpty && state.phone.isNotEmpty) {
              phoneController.text = state.phone;
            }
            final user = StorageHelper.getUser();
            if (emailController.text.isEmpty && user?.email != null) {
              emailController.text = user!.email!;
            }
          } else if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
            Navigator.pop(context);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return SafeArea(
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
                      validator: Validators.phone,
                    ),
                    const SizedBox(height: 22),
                    // البريد الإلكتروني
                    AccountField(
                      label: 'البريد الإلكتروني',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      hint: "info@gmail.com",
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 22),
                    // الاسم
                    AccountField(
                      label: 'الاسم الكامل',
                      controller: nameController,
                      hint: "احمد محمد",
                      validator: Validators.name,
                    ),
                    const SizedBox(height: 22),
                    // كلمة المرور (اختيارية)
                    AccountField(
                      label: 'كلمة المرور (اختياري)',
                      controller: passwordController,
                      obscureText: true,
                      hint: "اتركه فارغاً إذا لا تريد التغيير",
                      validator: (value) {
                        if (value == null || value.isEmpty) return null;
                        return Validators.password(value);
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
                        final pass = passwordController.text;
                        if (pass.isEmpty && (value == null || value.isEmpty)) return null;
                        return Validators.confirmPassword(value, pass);
                      },
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text('حفظ التغييرات',
                                style: TextStyle(color: AppTheme.labelColor, fontWeight: FontWeight.w700, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Account Field
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
          child: Text(label, style: const TextStyle(color: Color(0xFFB8B8BE), fontSize: 14)),
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            focusedBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF3A3A40))),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.red)),
            focusedErrorBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.red)),
            errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
            suffixIcon: const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Icon(Icons.edit_outlined, color: Colors.white, size: 18),
            ),
            suffixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 0),
          ),
        ),
      ],
    );
  }
}
