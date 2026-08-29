import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:soor_app/core/const/constans.dart';
import 'package:soor_app/core/utils/storage_helper.dart';
import 'package:soor_app/features/auth/Login screen/login_screen.dart';
import 'package:soor_app/features/auth/logic/auth_cubit.dart';
import 'package:soor_app/features/auth/logic/auth_state.dart';

import 'package:soor_app/features/more%20Screen/account_screen.dart';
import 'package:soor_app/features/more%20Screen/chat_history.dart';
import 'package:soor_app/features/more%20Screen/info_screen.dart';

class CardActionItem {
  final Widget icon;
  final String label;
  final VoidCallback onTap;

  const CardActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  void initState() {
    super.initState();
    // جيب البروفايل أول ما الشاشة تفتح
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.fieldBackground,
        centerTitle: true,
        title: Text(
          'المزيد',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppTheme.labelColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xff00394C),
              ),
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  String name = StorageHelper.getUserName();
                  String phone = StorageHelper.getUserPhone();
                  bool isLoading = false;

                  if (state is ProfileLoaded) {
                    name = state.name;
                    phone = state.phone;
                  } else if (state is ProfileLoading) {
                    isLoading = true;
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AccountScreen(),
                              ),
                            );
                          },
                          icon: SvgPicture.asset('assets/images/edit-05.svg'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                isLoading
                                    ? Container(
                                        width: 90,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: Colors.white24,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      )
                                    : Text(
                                        name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: AppTheme.labelColor,
                                        ),
                                      ),
                                const SizedBox(height: 4),
                                isLoading
                                    ? Container(
                                        width: 110,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: Colors.white12,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      )
                                    : Text(
                                        phone.isEmpty ? '—' : phone,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: AppTheme.hintColor,
                                        ),
                                      ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            CircleAvatar(
                              backgroundColor: AppTheme.fieldBorder,
                              radius: 25,
                              child: Icon(Icons.person, color: AppTheme.labelColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Builder(builder: (context) {
              final List<CardActionItem> actions = [
                CardActionItem(
                  icon: SvgPicture.asset('assets/images/globe-02.svg', width: 20, height: 20),
                  label: 'اللغة',
                  onTap: () {},
                ),
                CardActionItem(
                  icon: SvgPicture.asset('assets/images/message-dots-circle.svg', width: 20, height: 20),
                  label: 'المحادثة',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatHistory()),
                    );
                  },
                ),
                CardActionItem(
                  icon: SvgPicture.asset('assets/images/annotation-info.svg', width: 20, height: 20),
                  label: 'الشروط و الاحكام',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InfoScreen()),
                    );
                  },
                ),
                CardActionItem(
                  icon: SvgPicture.asset('assets/images/log-out-04-alt.svg', width: 20, height: 20),
                  label: 'تسجيل خروج',
                  onTap: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: AppTheme.fieldBackground,
                        title: Text('تأكيد تسجيل الخروج',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppTheme.labelColor, fontWeight: FontWeight.w700)),
                        content: Text('هل أنت متأكد أنك تريد تسجيل الخروج؟',
                            textAlign: TextAlign.center, style: TextStyle(color: AppTheme.hintColor)),
                        actionsAlignment: MainAxisAlignment.spaceBetween,
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text('إلغاء', style: TextStyle(color: AppTheme.hintColor)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('خروج', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                    if (confirmed != true) return;
                    if (!context.mounted) return;
                    await context.read<AuthCubit>().logout();
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (_) => false,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم تسجيل الخروج بنجاح'), backgroundColor: Colors.green),
                    );
                  },
                ),
              ];

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                itemCount: actions.length,
                itemBuilder: (context, index) {
                  final item = actions[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: CustomCardAction(
                      icon: item.icon,
                      label: item.label,
                      onTap: item.onTap,
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class CustomCardAction extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;

  const CustomCardAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppTheme.fieldBackground,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.chevron_left, color: Colors.white70),
              Row(
                children: [
                  Text(
                    label,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  icon,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
