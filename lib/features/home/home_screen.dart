import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:soor_app/conistans/constans.dart';
import 'package:soor_app/features/home/Chat/cahtScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  Timer? _timer;

  final List<String> images = [
    "assets/images/0befc0b0-d2fe-406d-ba81-3d6632b211fa.png",
    "assets/images/0befc0b0-d2fe-406d-ba81-3d6632b211fa.png",
    "assets/images/0befc0b0-d2fe-406d-ba81-3d6632b211fa.png",
  ];

  int currentPage = 0;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        currentPage++;

        if (currentPage >= images.length) {
          currentPage = 0;
        }

        _pageController.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Cahtscreen()),
          );
        },
        shape: const CircleBorder(),
        backgroundColor: AppTheme.primaryColor,
        child: Icon(Icons.chat, color: AppTheme.labelColor),
      ),
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

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 220,
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: images.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.asset(images[index], fit: BoxFit.fitWidth);
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  SmoothPageIndicator(
                    controller: _pageController,
                    count: images.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: Color(0xff00394C),
                      dotColor: Colors.grey.shade300,
                      dotHeight: 7,
                      dotWidth: 7,
                      expansionFactor: 3,
                      spacing: 5,
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios_new,
                        size: 15,
                        color: AppTheme.primaryColor,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "المزيد",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "الخدمات",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.labelColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomCircleButton(
                    icon: Icons.people_outline,
                    backgroundColor: LinearGradient(
                      colors: [Color(0xff007AA2), Color(0xff00394C)],
                    ),
                    text: 'مناسبات',
                  ),
                  SizedBox(width: 10),
                  CustomCircleButton(
                    icon: Icons.person_outline,
                    backgroundColor: LinearGradient(
                      colors: [Color(0xffE1801E), Color(0xff61370D)],
                    ),
                    text: 'طلب فرد',
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "الحجز الحالى",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppTheme.labelColor,
                ),
              ),
              SizedBox(height: 20),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.fieldBorder,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 60,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color(0xff039855),
                            ),
                            child: Center(
                              child: Text(
                                "منتهي",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: AppTheme.labelColor,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "#12336455",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppTheme.labelColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "اليوم 8:00 م الى 11:00 م",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: AppTheme.hintColor,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "ريال",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                "1600",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.arrow_back_ios_new,
                            size: 15,
                            color: Color(0xff2D9EC4),
                          ),
                          SizedBox(width: 9),
                          Text(
                            "اضافة تقييم",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color(0xff2D9EC4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),
              Text(
                "اراء عملائنا",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppTheme.labelColor,
                ),
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  CustomReviewCard(
                    name: 'محمد احمد ابراهيم',
                    comment: 'خدمة ممتازة مع الالتزام في المواعيد',
                    rating: 5,
                  ),

                  CustomReviewCard(
                    name: 'محمد احمد ابراهيم',
                    comment: 'خدمة ممتازة مع الالتزام في المواعيد',
                    rating: 4.5,
                  ),

                  CustomReviewCard(
                    name: 'محمد احمد ابراهيم',
                    comment: 'خدمة ممتازة مع الالتزام في المواعيد',
                    rating: 3,
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

class CustomReviewCard extends StatelessWidget {
  final String name;
  final String comment;
  final double rating;

  const CustomReviewCard({
    super.key,
    required this.name,
    required this.comment,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xff151515),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xff292929), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ⭐ Stars
          Expanded(
            flex: 4,
            child: FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: _buildStars(),
            ),
          ),

          const SizedBox(width: 12),

          // 👤 Name + Comment
          Expanded(
            flex: 6,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    comment,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xff858585),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
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

  Widget _buildStars() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starNumber = index + 1;

        IconData icon;
        Color color;

        if (rating >= starNumber) {
          icon = Icons.star;
          color = const Color(0xffffb31a);
        } else if (rating >= starNumber - 0.5) {
          icon = Icons.star_half;
          color = const Color(0xffffb31a);
        } else {
          icon = Icons.star;
          color = const Color(0xffeeeeee);
        }

        return Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Icon(icon, size: 32, color: color),
        );
      }),
    );
  }
}
