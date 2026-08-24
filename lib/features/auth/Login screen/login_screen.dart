import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:soor_app/conistans/constans.dart';
import 'package:soor_app/features/auth/Forget%20password/forget_password.dart';
import 'package:soor_app/features/auth/Register%20screen/register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool password = true;
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController passwordcontroller = TextEditingController();
    final GlobalKey<FormState> formkey = GlobalKey<FormState>();

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
      body: Stack(
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
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 8,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: formkey,
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
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "من فضلك ادخل رقم الموبايل";
                                }

                                final phoneRegex = RegExp(
                                  r'^(010|011|012|015)[0-9]{8}$',
                                );

                                if (!phoneRegex.hasMatch(value.trim())) {
                                  return "رقم الموبايل غير صحيح";
                                }

                                return null;
                              },
                              hintText: "+966 000 000 00",
                              label: "رقم الجوال",
                            ),

                            const SizedBox(height: 15),

                            TextFormFieldWidget(
                              controller: passwordcontroller,
                              obscureText: password,
                              maxLines: 1,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "من فضلك ادخل كلمة المرور";
                                }

                                if (value.length < 6) {
                                  return "كلمة المرور يجب ألا تقل عن 6 أحرف";
                                }

                                return null;
                              },
                              label: "كلمة المرور",
                              keyboardType: TextInputType.visiblePassword,
                              hintText: "*********",
                              isPassword: true,
                            ),

                            const SizedBox(height: 25),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgetPassword(),
                                  ),
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

                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: MaterialButton(
                                onPressed: () {
                                  final isFormValid = formkey.currentState!
                                      .validate();

                                  if (!isFormValid) {
                                    return;
                                  }
                                },
                                child: Row(
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

                  SizedBox(height: 30),

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
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(),
                                  ),
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
      ),
    );
  }
}
