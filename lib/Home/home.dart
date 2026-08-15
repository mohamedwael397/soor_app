import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soor_app/Home/appointment_screens.dart';
import 'package:soor_app/Home/home_screen.dart';
import 'package:soor_app/Home/more_screen.dart';
import 'package:soor_app/Home/services_screen.dart';
import 'package:soor_app/conistans/constans.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int current_index = 0;

  final List<Widget> Screens = [
    HomeScreen(),
    ServicesScreen(),
    AppointmentScreens(),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.fieldBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.fieldBackground,
        leading: IconButton(
          onPressed: () {},
          icon: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.fieldBorder,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                "assets/images/icon.svg",
                width: 25,
                height: 25,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset("assets/images/Asset 2 1.svg"),
          ),
        ],
      ),

      body: Screens[current_index],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.fieldBorder,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: AppTheme.fieldBorder,

          elevation: 0,

          type: BottomNavigationBarType.fixed,

          currentIndex: current_index,

          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: Colors.grey,

          selectedFontSize: 12,
          unselectedFontSize: 11,

          showSelectedLabels: true,
          showUnselectedLabels: true,

          onTap: (index) {
            setState(() {
              current_index = index;
            });
          },

          items: [
            // الرئيسية
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/images/Frame64.svg",
                width: 24,
                height: 24,
              ),
              activeIcon: SvgPicture.asset(
                "assets/images/Frame64.svg",
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  AppTheme.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              label: "الرئيسية",
            ),

            // الخدمات
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/images/Frame63.svg",
                width: 24,
                height: 24,
              ),
              activeIcon: SvgPicture.asset(
                "assets/images/Frame63.svg",
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  AppTheme.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              label: "الخدمات",
            ),

            // الحجوزات
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/images/Frame63.svg",
                width: 24,
                height: 24,
              ),
              activeIcon: SvgPicture.asset(
                "assets/images/Frame63.svg",
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  AppTheme.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              label: "الحجوزات",
            ),

            // المزيد
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/images/Frame61.svg",
                width: 24,
                height: 24,
              ),
              activeIcon: SvgPicture.asset(
                "assets/images/Frame61.svg",
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  AppTheme.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              label: "المزيد",
            ),
          ],
        ),
      ),
    );
  }
}
