import 'package:flutter/material.dart';
import 'package:soor_app/core/const/constans.dart';
import 'package:soor_app/features/Location/location_screen.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> services = [
      {
        "icon": Icons.person_outline,
        "colors": [Color(0xffE1801E), Color(0xff61370D)],
        "title": "طلب فرد",
        "description": "وصف الخدمة هنا",
        "onpress": () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LocationScreen()),
          );
        },
      },
      {
        "icon": Icons.people_outline,
        "colors": [Color(0xff007AA2), Color(0xff00394C)],
        "title": "طلب شركة",
        "description": "وصف الخدمة هنا",
        "onpress": () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LocationScreen()),
          );
        },
      },
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.fieldBackground,
        centerTitle: true,
        title: Text(
          "الخدمات",
          style: TextStyle(
            color: AppTheme.labelColor,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          final service = services[index];
          return CustomServiceCard(
            icon: service["icon"],
            iconBackground: LinearGradient(colors: service["colors"]),
            title: service["title"],
            description: service["description"],
            onPressed: service["onpress"],
          );
        },
      ),
    );
  }
}

class CustomCircle extends StatelessWidget {
  final IconData icon;
  final Gradient backgroundColor;

  const CustomCircle({
    super.key,
    required this.icon,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(child: Icon(icon, color: Colors.white, size: 38)),
      ),
    );
  }
}

class CustomServiceCard extends StatelessWidget {
  final IconData icon;
  final Gradient iconBackground;
  final String title;
  final String description;
  final VoidCallback onPressed;

  const CustomServiceCard({
    super.key,
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.description,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.fieldBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Column(
            children: [
              CustomCircle(icon: icon, backgroundColor: iconBackground),

              const SizedBox(height: 8),

              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: AppTheme.labelColor,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                description,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: AppTheme.hintColor,
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 40,
                child: MaterialButton(
                  onPressed: onPressed,
                  color: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back_ios_new,
                        color: AppTheme.labelColor,
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "ابدء الآن",
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
    );
  }
}
