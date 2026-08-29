import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:soor_app/core/const/constans.dart';
import 'package:soor_app/core/utils/validators.dart';
import 'package:soor_app/features/auth/Forget password/forget_password.dart';
import 'package:soor_app/features/auth/Register screen/register_screen.dart';
import 'package:soor_app/features/auth/logic/auth_cubit.dart';
import 'package:soor_app/features/auth/logic/auth_state.dart';
import 'package:soor_app/features/home/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().login(
          phone: _phoneCtrl.text.trim(),
          password: _passCtrl.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.fieldBorder,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: AppTheme.fieldBackground,
              child: Center(
                child: Icon(Icons.close, color: AppTheme.labelColor),
              ),
            ),
          ),
        ],
        leadingWidth: 100,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.language, color: AppTheme.primaryColor),
            const SizedBox(width: 5),
            Text(
              "English",
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
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
              MaterialPageRoute(builder: (_) => const Home()),
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
                                  "مرحباً بك مرة أخرى!",
                                  style: TextStyle(
                                    color: AppTheme.labelColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                  ),
                                ),
                                Text(
                                  "مع سور ... انت فى السيلم ، قم بتسجيل الدخول الآن",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppTheme.labelColor,
                                    fontWeight: FontWeight.w500,
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
                                const SizedBox(height: 15),
                                TextFormFieldWidget(
                                  controller: _passCtrl,
                                  maxLines: 1,
                                  validator: Validators.password,
                                  label: "كلمة المرور",
                                  keyboardType: TextInputType.visiblePassword,
                                  hintText: "*********",
                                  isPassword: true,
                                  obscureText: true,
                                ),
                                const SizedBox(height: 25),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const ForgetPassword()),
                                    );
                                  },
                                  child: Text(
                                    "هل نسيت كلمة المرور؟",
                                    style: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : _login,
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
                                              Icon(
                                                Icons.arrow_back_ios,
                                                color: AppTheme.labelColor,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                "تسجيل دخول",
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: "لا تمتلك حساب ؟",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: " حساب جديد",
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                                    );
                                  },
                              ),
                            ],
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
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
