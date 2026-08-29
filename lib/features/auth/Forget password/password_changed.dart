import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soor_app/core/const/constans.dart';
import 'package:soor_app/features/auth/Login screen/login_screen.dart';

class PasswordChanged extends StatelessWidget {
  const PasswordChanged({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.fieldBackground,
      body: Stack(
        children: [
          Positioned(
            top: 450,
            child: Image.asset("assets/images/Vector.png", color: AppTheme.fieldBorder),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/images/Illustration Success.svg"),
                  const SizedBox(height: 20),
                  Text(
                    "تم بنجاح!️",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppTheme.labelColor),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "تم تغيير كلمة المرور بنجاح",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppTheme.labelColor),
                  ),
                  const SizedBox(height: 150),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (_) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text(
                        "تسجيل دخول",
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: AppTheme.labelColor),
                      ),
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
