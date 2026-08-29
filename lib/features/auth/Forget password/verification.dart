import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:soor_app/core/const/constans.dart';
import 'package:soor_app/features/auth/Forget password/reset_password.dart';
import 'package:soor_app/features/auth/logic/auth_cubit.dart';
import 'package:soor_app/features/auth/logic/auth_state.dart';
import 'package:soor_app/features/home/home.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _timer;
  int _seconds = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    // محاكاة: لو السيرفر رجع OTP في رسالة النجاح، املاه تلقائياً
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final otp = context.read<AuthCubit>().lastOtp;
      if (otp != null && otp.length == 4 && _controller.text.isEmpty) {
        _controller.text = otp;
        setState(() {});
      }
    });
  }

  void _startTimer() {
    _seconds = 60;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds > 0) {
        if (mounted) setState(() => _seconds--);
      } else {
        if (mounted) setState(() => _canResend = true);
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  String _formatTime(int s) {
    final m = s ~/ 60;
    final sec = s % 60;
    return "$m:${sec.toString().padLeft(2, '0')}";
  }

  void _verify() {
    if (_controller.text.length != 4) return;
    context.read<AuthCubit>().verifyCode(code: _controller.text.trim());
  }

  void _resend() {
    if (!_canResend) return;
    context.read<AuthCubit>().resendCode();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    final phone = cubit.pendingPhone ?? "رقمك";
    final isForget = cubit.otpPurpose == OtpPurpose.forgetPassword;

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
        // نستقبل فقط حالات الـ OTP عشان متتداخلش مع نجاح الـ Login/Register السابق
        listenWhen: (prev, curr) =>
            curr is OtpVerified ||
            curr is OtpResent ||
            curr is OtpSent ||
            curr is AuthFailure ||
            curr is OtpSending,
        listener: (context, state) {
          if (state is OtpVerified) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
            if (isForget) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ResetPassword()),
              );
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const Home()),
                (_) => false,
              );
            }
          } else if (state is OtpResent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
            _startTimer();
            // محاكاة: املأ الـ OTP تلقائياً من السيرفر
            if (state.otp != null && state.otp!.length == 4) {
              _controller.text = state.otp!;
              setState(() {});
            }
          } else if (state is OtpSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
            // محاكاة: املأ الـ OTP تلقائياً
            if (state.otp != null && state.otp!.length == 4) {
              _controller.text = state.otp!;
              setState(() {});
            }
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        buildWhen: (prev, curr) =>
            curr is OtpVerifying ||
            curr is OtpSending ||
            curr is OtpSent ||
            curr is OtpResent ||
            curr is OtpVerified ||
            curr is AuthFailure ||
            curr is AuthInitial,
        builder: (context, state) {
          final isLoading = state is OtpVerifying || state is OtpSending;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  const Text(
                    'التحقق',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'أدخل رمز التحقق الذي أرسلناه إلى\n$phone',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                  // محاكاة: اعرض الكود القادم من السيرفر
                  if (cubit.lastOtp != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.info_outline, color: Colors.amber, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'كود المحاكاة: ${cubit.lastOtp}',
                            style: const TextStyle(color: Colors.amber, fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  const SizedBox(height: 22),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: PinCodeTextField(
                      appContext: context,
                      controller: _controller,
                      length: 4,
                      keyboardType: TextInputType.number,
                      autoFocus: true,
                      enableActiveFill: true,
                      cursorColor: Colors.white,
                      animationType: AnimationType.scale,
                      animationDuration: const Duration(milliseconds: 300),
                      textStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(8),
                        fieldHeight: 52,
                        fieldWidth: 52,
                        borderWidth: 1,
                        inactiveColor: Colors.transparent,
                        selectedColor: const Color(0xff00AEEF),
                        activeColor: Colors.transparent,
                        inactiveFillColor: AppTheme.fieldBorder,
                        selectedFillColor: AppTheme.fieldBorder,
                        activeFillColor: AppTheme.fieldBorder,
                      ),
                      onChanged: (_) => setState(() {}),
                      onCompleted: (_) => _verify(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_formatTime(_seconds),
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.labelColor)),
                      const SizedBox(width: 8),
                      Icon(Icons.timer_outlined, color: AppTheme.labelColor),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _canResend && !isLoading ? _resend : null,
                    child: Text(
                      "إعادة إرسال الكود",
                      style: TextStyle(
                        color: _canResend ? Colors.amber : Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        decoration: _canResend ? TextDecoration.underline : null,
                      ),
                    ),
                  ),
                  if (isLoading) ...[
                    const SizedBox(height: 12),
                    const SizedBox(
                        width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                    Text(
                      state is OtpSending ? "جاري إرسال الكود..." : "جاري التحقق...",
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: (_controller.text.length == 4 && !isLoading) ? _verify : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        disabledBackgroundColor: AppTheme.primaryColor.withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('تحقق',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
