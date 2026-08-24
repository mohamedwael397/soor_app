import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soor_app/conistans/constans.dart';
import 'package:soor_app/features/auth/Login%20screen/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool password = true;
  bool confirmpassword = true;
  bool isChecked = false;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController confirmpasswordcontroller =
      TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    emailcontroller.dispose();
    namecontroller.dispose();
    passwordcontroller.dispose();
    confirmpasswordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.fieldBackground,
        body: Stack(
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
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 8,
                      ),
                      child: Column(
                        children: [
                          // =========================
                          // Form
                          // =========================
                          Form(
                            key: formkey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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

                                // =========================
                                // Phone
                                // =========================
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

                                // =========================
                                // Email
                                // =========================
                                TextFormFieldWidget(
                                  controller: emailcontroller,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "من فضلك ادخل البريد الإلكترونى";
                                    }

                                    final emailRegex = RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                    );

                                    if (!emailRegex.hasMatch(value.trim())) {
                                      return "البريد الإلكترونى غير صحيح";
                                    }

                                    return null;
                                  },
                                  hintText: "البريد الإلكترونى",
                                  label: "البريد الإلكترونى",
                                ),

                                const SizedBox(height: 15),

                                // =========================
                                // Name
                                // =========================
                                TextFormFieldWidget(
                                  controller: namecontroller,
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "من فضلك ادخل الاسم كامل";
                                    }

                                    if (value.trim().length < 3) {
                                      return "الاسم يجب ألا يقل عن 3 أحرف";
                                    }

                                    return null;
                                  },
                                  hintText: "الاسم كامل",
                                  label: "ادخل الاسم كامل",
                                ),

                                const SizedBox(height: 15),

                                // =========================
                                // Password
                                // =========================
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

                                const SizedBox(height: 15),

                                // =========================
                                // Confirm Password
                                // =========================
                                TextFormFieldWidget(
                                  controller: confirmpasswordcontroller,
                                  obscureText: confirmpassword,
                                  maxLines: 1,
                                  isPassword: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "من فضلك أكد كلمة المرور";
                                    }

                                    if (value != passwordcontroller.text) {
                                      return "كلمة المرور غير متطابقة";
                                    }

                                    return null;
                                  },
                                  label: "تأكيد كلمة المرور",
                                  keyboardType: TextInputType.visiblePassword,
                                  hintText: "*********",
                                ),

                                const SizedBox(height: 15),

                                // =========================
                                // Terms & Privacy
                                // =========================
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Checkbox(
                                      value: isChecked,
                                      onChanged: (value) {
                                        setState(() {
                                          isChecked = value ?? false;
                                        });
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
                                          TextSpan(
                                            text: "أوافق على شروط الخدمة و ",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "سياسة الخصوصية",
                                            style: TextStyle(
                                              color: Colors.amber,
                                              decoration:
                                                  TextDecoration.underline,
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

                                // =========================
                                // Register Button
                                // =========================
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

                                      if (!isChecked) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "من فضلك وافق على شروط الخدمة وسياسة الخصوصية",
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );

                                        return;
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.arrow_back_ios,
                                          color: AppTheme.labelColor,
                                          size: 20,
                                        ),
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

                          // =========================
                          // Login Text
                          // =========================
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
                                            builder: (context) =>
                                                const LoginScreen(),
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
