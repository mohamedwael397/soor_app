import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:soor_app/conistans/constans.dart';
import 'package:soor_app/features/home/Chat/call_screen.dart';

class Cahtscreen extends StatelessWidget {
  Cahtscreen({super.key});

  final TextEditingController chatcontroller = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.fieldBackground,
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.all(5),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.fieldBorder,
              ),
              child: Icon(Icons.arrow_back, color: AppTheme.labelColor),
            ),
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CallScreen()),
                );
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xff005875),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset("assets/images/phone-call-01.svg"),
              ),
            ),
          ),
        ],

        title: SvgPicture.asset("assets/images/Asset 2 1.svg", height: 35),
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.82,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff202020),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Icon(
                          Icons.person_outline,
                          size: 18,
                          color: AppTheme.labelColor,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "احمد",
                              style: TextStyle(
                                color: AppTheme.labelColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              "انتظرك في الموعد إن شاء الله",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: AppTheme.labelColor,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 5),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "✓✓",
                      style: TextStyle(color: Colors.amber, fontSize: 11),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "09:15",
                      style: TextStyle(
                        color: AppTheme.labelColor.withValues(alpha: 0.5),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.82,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xff00394C),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "Soor",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 3),

                            const Text(
                              "إن شاء الله أكون موجود في الموعد",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Avatar
                      Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff005875),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SvgPicture.asset("assets/images/Group.svg"),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 5),

                // Time + Checks
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "✓✓",
                      style: TextStyle(color: Colors.amber, fontSize: 11),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "09:15",
                      style: TextStyle(
                        color: AppTheme.labelColor.withValues(alpha: 0.5),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),

      // ================= MESSAGE INPUT =================
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 120,
          color: AppTheme.fieldBorder,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              // Text Field
              Expanded(
                child: TextFormFieldWidget(
                  controller: chatcontroller,
                  validator: (value) {
                    return null;
                  },
                  hintText: "رسالتك هنا",
                  label: "",
                ),
              ),

              const SizedBox(width: 8),

              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.send, color: AppTheme.labelColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
