import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soor_app/core/const/constans.dart';
import 'package:soor_app/features/auth/Forget%20password/password_changed.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordstate();
}

class _ResetPasswordstate extends State<ResetPassword> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool password = true;
  bool confirmpassword = true;

  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController confirmpasswordcontroller =
      TextEditingController();

  @override
  void dispose() {
    passwordcontroller.dispose();
    confirmpasswordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.fieldBorder,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: AppTheme.labelColor,
            ),
          ),
        ),
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
                                  "إعادة ضبط كلمة المرور",
                                  style: TextStyle(
                                    color: AppTheme.labelColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
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

                                const SizedBox(height: 50),

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

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PasswordChanged(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "حفظ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
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
        ),
      ),
    );
  }
}
