import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:soor_app/core/const/constans.dart';
import 'package:soor_app/core/utils/validators.dart';
import 'package:soor_app/features/auth/Forget password/verification.dart';
import 'package:soor_app/features/auth/logic/auth_cubit.dart';
import 'package:soor_app/features/auth/logic/auth_state.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _phoneCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().forgetPassword(phone: _phoneCtrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.fieldBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.fieldBorder,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: AppTheme.labelColor),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is OtpSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VerificationScreen()),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading || state is OtpSending;
          return Stack(
            children: [
              Positioned(
                top: 450,
                child: Image.asset(
                  "assets/images/Vector.png",
                  color: AppTheme.fieldBorder,
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                SvgPicture.asset("assets/images/Asset 2 1.svg"),
                                const SizedBox(height: 15),
                                Text(
                                  "هل نسيت كلمة المرور؟",
                                  style: TextStyle(
                                    color: AppTheme.labelColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "أدخل رقم جوالك وسنرسل لك كود التحقق",
                                  style: TextStyle(
                                    color: AppTheme.hintColor,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 25),
                                TextFormFieldWidget(
                                  controller: _phoneCtrl,
                                  keyboardType: TextInputType.phone,
                                  validator: Validators.phone,
                                  hintText: "+966 500 000 000",
                                  label: "رقم الجوال",
                                ),
                                const SizedBox(height: 50),
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: isLoading
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.arrow_back_ios,
                                                  color: AppTheme.labelColor, size: 20),
                                              const SizedBox(width: 5),
                                              Text(
                                                "إرسال",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  color: AppTheme.labelColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
