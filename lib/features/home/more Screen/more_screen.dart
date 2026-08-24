import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soor_app/Home/more%20Screen/account_screen.dart';
import 'package:soor_app/Home/more%20Screen/chat_history.dart';
import 'package:soor_app/Home/more%20Screen/info_screen.dart';
import 'package:soor_app/conistans/constans.dart';

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

class MoreScreen extends StatelessWidget {
  MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CardActionItem> actions = [
      CardActionItem(
        icon: SvgPicture.asset(
          'assets/images/globe-02.svg',
          width: 20,
          height: 20,
        ),
        label: 'اللغة',
        onTap: () {
          print('اللغة');
        },
      ),
      CardActionItem(
        icon: SvgPicture.asset(
          'assets/images/message-dots-circle.svg',
          width: 20,
          height: 20,
        ),
        label: 'المحادثة',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatHistory()),
          );
        },
      ),

      CardActionItem(
        icon: SvgPicture.asset(
          'assets/images/annotation-info.svg',
          width: 20,
          height: 20,
        ),
        label: 'الشروط و الاحكام',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InfoScreen()),
          );
        },
      ),
      CardActionItem(
        icon: SvgPicture.asset(
          'assets/images/log-out-04-alt.svg',
          width: 20,
          height: 20,
        ),
        label: 'تسجيل خروج',
        onTap: () {
          print('Logout');
        },
      ),
    ];
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
              child: Row(
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
                            Text(
                              'كريم خليل السيد',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: AppTheme.labelColor,
                              ),
                            ),
                            Text(
                              '+9054545656',
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
              ),
            ),
          ),
          SizedBox(height: 40),

          Expanded(
            child: ListView.builder(
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
            ),
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
