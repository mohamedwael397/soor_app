import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soor_app/core/const/constans.dart';
import 'package:soor_app/core/utils/validators.dart';
import 'package:soor_app/features/auth/Forget password/password_changed.dart';
import 'package:soor_app/features/auth/logic/auth_cubit.dart';
import 'package:soor_app/features/auth/logic/auth_state.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().resetPassword(
          password: _passCtrl.text,
          passwordConfirmation: _confirmCtrl.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.fieldBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.fieldBorder,
        centerTitle: true,
        title: Text("تغيير كلمة المرور",
            style: TextStyle(color: AppTheme.labelColor, fontSize: 16, fontWeight: FontWeight.w600)),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: AppTheme.labelColor),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.green));
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PasswordChanged()));
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
          }
        },
        builder: (context, state) {
          final loading = state is AuthLoading;
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  TextFormFieldWidget(
                    controller: _passCtrl,
                    validator: Validators.password,
                    label: "كلمة المرور الجديدة",
                    hintText: "*********",
                    isPassword: true,
                    obscureText: true,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 16),
                  TextFormFieldWidget(
                    controller: _confirmCtrl,
                    validator: (v) => Validators.confirmPassword(v, _passCtrl.text),
                    label: "تأكيد كلمة المرور",
                    hintText: "*********",
                    isPassword: true,
                    obscureText: true,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: loading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: loading
                          ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text("حفظ", style: TextStyle(color: AppTheme.labelColor, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
