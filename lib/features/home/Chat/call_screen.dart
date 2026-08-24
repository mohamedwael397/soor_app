import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soor_app/conistans/constans.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.fieldBackground,
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.fieldBorder,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.cancel_outlined, color: AppTheme.labelColor),
              ),
            ),
          ),
        ),
      ),
      body: Expanded(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "جاري الاتصال",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Color(0xff2D9EC4),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Soor",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 53,
                  color: Color(0xff878787),
                ),
              ),
              SizedBox(height: 40),

              SizedBox(
                width: 279,
                height: 279,
                child: SvgPicture.asset("assets/images/Group 26669.svg"),
              ),
              SizedBox(height: 80),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CallActionButton(
                    icon: Icons.volume_up,
                    color: AppTheme.fieldBackground,
                    onTap: () {},
                  ),
                  SizedBox(width: 15),
                  CallActionButton(
                    icon: Icons.mic,
                    color: AppTheme.fieldBackground,
                    onTap: () {},
                  ),
                  SizedBox(width: 15),

                  CallActionButton(
                    icon: Icons.phone,
                    color: Colors.red,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CallActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;
  final VoidCallback? onTap;

  const CallActionButton({
    super.key,
    required this.icon,
    required this.color,
    this.size = 80,
    this.iconSize = 38,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Center(
          child: Icon(icon, color: Colors.white, size: iconSize),
        ),
      ),
    );
  }
}
