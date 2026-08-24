import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:soor_app/conistans/constans.dart';
import 'package:soor_app/features/auth/Forget%20password/verification.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();
    final GlobalKey<FormState> formkey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppTheme.fieldBackground,
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
                              "هل نسيت كلمة المرور؟",
                              style: TextStyle(
                                color: AppTheme.labelColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
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

                            const SizedBox(height: 50),

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
                                          const VerificationScreen(),
                                    ),
                                  );
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

                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
