import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soor_app/core/const/constans.dart';
import 'package:soor_app/core/utils/validators.dart';
import 'package:soor_app/features/auth/Forget password/password_changed.dart';
import 'package:soor_app/features/auth/logic/auth_cubit.dart';
import 'package:soor_app/features/auth/logic/auth_state.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordstate();
}

class _ResetPasswordstate extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  final passwordcontroller = TextEditingController();
  final confirmpasswordcontroller = TextEditingController();

  @override
  void dispose() {
    passwordcontroller.dispose();
    confirmpasswordcontroller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().resetPassword(
          password: passwordcontroller.text,
          passwordConfirmation: confirmpasswordcontroller.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.fieldBorder,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new_outlined, color: AppTheme.labelColor),
          ),
        ),
        backgroundColor: AppTheme.fieldBackground,
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.green),
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const PasswordChanged()),
                (_) => false,
              );
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return Stack(
              children: [
                Positioned(
                  top: 400,
                  child: Image.asset("assets/images/Vector.png", color: AppTheme.fieldBorder),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                          child: Column(
                            children: [
                              Form(
                                key: _formKey,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                child: Column(
                                  children: [
                                    SvgPicture.asset("assets/images/Asset 2 1.svg"),
                                    const SizedBox(height: 15),
                                    Text(
                                      "إعادة ضبط كلمة المرور",
                                      style: TextStyle(
                                        color: AppTheme.labelColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    TextFormFieldWidget(
                                      controller: passwordcontroller,
                                      maxLines: 1,
                                      validator: Validators.password,
                                      label: "كلمة المرور الجديدة",
                                      keyboardType: TextInputType.visiblePassword,
                                      hintText: "*********",
                                      isPassword: true,
                                      obscureText: true,
                                    ),
                                    const SizedBox(height: 15),
                                    TextFormFieldWidget(
                                      controller: confirmpasswordcontroller,
                                      maxLines: 1,
                                      isPassword: true,
                                      obscureText: true,
                                      validator: (v) => Validators.confirmPassword(v, passwordcontroller.text),
                                      label: "تأكيد كلمة المرور",
                                      keyboardType: TextInputType.visiblePassword,
                                      hintText: "*********",
                                    ),
                                    const SizedBox(height: 50),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 52,
                                      child: ElevatedButton(
                                        onPressed: isLoading ? null : _submit,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppTheme.primaryColor,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        ),
                                        child: isLoading
                                            ? const SizedBox(
                                                width: 22,
                                                height: 22,
                                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                            : Text(
                                                "حفظ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                  color: AppTheme.labelColor,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
