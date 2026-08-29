import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soor_app/core/const/constans.dart';
import 'package:soor_app/core/utils/validators.dart';
import 'package:soor_app/features/auth/Login screen/login_screen.dart';
import 'package:soor_app/features/auth/Forget password/verification.dart';
import 'package:soor_app/features/auth/logic/auth_cubit.dart';
import 'package:soor_app/features/auth/logic/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;

  final phoneController = TextEditingController();
  final emailcontroller = TextEditingController();
  final namecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final confirmpasswordcontroller = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    emailcontroller.dispose();
    namecontroller.dispose();
    passwordcontroller.dispose();
    confirmpasswordcontroller.dispose();
    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;
    if (!isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("من فضلك وافق على شروط الخدمة وسياسة الخصوصية"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    context.read<AuthCubit>().register(
          name: namecontroller.text.trim(),
          phone: phoneController.text.trim(),
          email: emailcontroller.text.trim(),
          password: passwordcontroller.text,
          passwordConfirmation: confirmpasswordcontroller.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.fieldBackground,
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
                  top: 400,
                  child: Image.asset(
                    "assets/images/Vector.png",
                    color: AppTheme.fieldBorder,
                  ),
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
                                      "!إنشاء حساب",
                                      style: TextStyle(
                                        color: AppTheme.labelColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                    const SizedBox(height: 25),
                                    TextFormFieldWidget(
                                      controller: phoneController,
                                      keyboardType: TextInputType.phone,
                                      validator: Validators.phone,
                                      hintText: "+966 500 000 000",
                                      label: "رقم الجوال",
                                    ),
                                    const SizedBox(height: 15),
                                    TextFormFieldWidget(
                                      controller: emailcontroller,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: Validators.email,
                                      hintText: "البريد الإلكتروني",
                                      label: "البريد الإلكتروني",
                                    ),
                                    const SizedBox(height: 15),
                                    TextFormFieldWidget(
                                      controller: namecontroller,
                                      keyboardType: TextInputType.name,
                                      validator: Validators.name,
                                      hintText: "الاسم كامل",
                                      label: "ادخل الاسم كامل",
                                    ),
                                    const SizedBox(height: 15),
                                    TextFormFieldWidget(
                                      controller: passwordcontroller,
                                      maxLines: 1,
                                      validator: Validators.password,
                                      label: "كلمة المرور",
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
                                      validator: (v) => Validators.confirmPassword(
                                          v, passwordcontroller.text),
                                      label: "تأكيد كلمة المرور",
                                      keyboardType: TextInputType.visiblePassword,
                                      hintText: "*********",
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Checkbox(
                                          value: isChecked,
                                          onChanged: (value) {
                                            setState(() => isChecked = value ?? false);
                                          },
                                          activeColor: Colors.lightBlue,
                                          checkColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: "أوافق على شروط الخدمة و ",
                                                style: TextStyle(color: Colors.white, fontSize: 14),
                                              ),
                                              TextSpan(
                                                text: "سياسة الخصوصية",
                                                style: const TextStyle(
                                                  color: Colors.amber,
                                                  decoration: TextDecoration.underline,
                                                  decorationColor: Colors.amber,
                                                  decorationThickness: 1.5,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 52,
                                      child: ElevatedButton(
                                        onPressed: isLoading ? null : _register,
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
                                                    "تسجيل حساب",
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
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15, top: 20),
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "هل تمتلك حساب بالفعل؟ ",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "تسجيل دخول",
                                        style: const TextStyle(
                                          color: Colors.amber,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => const LoginScreen()),
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
