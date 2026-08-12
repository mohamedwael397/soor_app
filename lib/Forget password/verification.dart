import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:soor_app/Forget%20password/reset_password.dart';
import 'package:soor_app/conistans/constans.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Title
              const Text(
                'التحقق',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 4),

              // Description
              const Text(
                'أدخل رمز التحقق الذي أرسلناه إلى\n'
                '966+ 000 000 000',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 18),

              // OTP
              Directionality(
                textDirection: TextDirection.ltr,
                child: PinCodeTextField(
                  appContext: context,
                  controller: _controller,
                  length: 5,
                  keyboardType: TextInputType.number,
                  autoFocus: true,
                  enableActiveFill: true,
                  cursorColor: Colors.white,
                  animationType: AnimationType.scale,
                  animationDuration: const Duration(milliseconds: 300),
                  animationCurve: Curves.bounceInOut,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 38,
                    fieldWidth: 38,
                    borderWidth: 1,
                    inactiveColor: Colors.transparent,
                    selectedColor: const Color(0xff00AEEF),
                    activeColor: Colors.transparent,
                    inactiveFillColor: AppTheme.fieldBorder,
                    selectedFillColor: AppTheme.fieldBorder,
                    activeFillColor: AppTheme.fieldBorder,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),

              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "1:00",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.labelColor,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.timer_outlined, color: AppTheme.labelColor),
                ],
              ),

              const SizedBox(height: 25),
              Text.rich(
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
                    ),
                  ],
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 15),

              // Verify Button
              SizedBox(
                width: double.infinity,
                height: 30,
                child: ElevatedButton(
                  onPressed: _controller.text.length == 5
                      ? () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResetPassword(),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    disabledBackgroundColor: AppTheme.primaryColor.withOpacity(
                      0.4,
                    ),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'تحقق',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
