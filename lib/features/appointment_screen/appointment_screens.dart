import 'package:flutter/material.dart';
import 'package:soor_app/core/const/constans.dart';
import 'package:soor_app/features/booking_details/booking_details_screen.dart';

class AppointmentScreens extends StatelessWidget {
  AppointmentScreens({super.key});

  final List<Map<String, dynamic>> orders = [
    {
      "statusColor": const Color(0xff00394C),
      "statusName": "قبول الحارس",
      "price": "1600",
      "time": "اليوم 8:00 م الى 11:00 م",
      "id": "#12336455",
      "isFinished": false,
    },
    {
      "statusColor": const Color(0xffDC6803),
      "statusName": "قيد التنفيذ",
      "price": "1200",
      "time": "غداً 6:00 م الى 9:00 م",
      "id": "#12336456",
      "isFinished": false,
    },
    {
      "statusColor": const Color(0xff039855),
      "statusName": "منتهي",
      "price": "1800",
      "time": "أمس 7:00 م الى 10:00 م",
      "id": "#12336457",
      "isFinished": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.fieldBackground,
        title: Text(
          "الحجوزات",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppTheme.labelColor,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ServiceOrderCard(
                  statusColor: order["statusColor"],
                  statusName: order["statusName"],
                  price: order["price"],
                  time: order["time"],
                  id: order["id"],
                  isFinished: order["isFinished"],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ServiceOrderCard extends StatelessWidget {
  final Color statusColor;
  final String statusName;
  final String price;
  final String time;
  final String id;
  final bool isFinished;

  const ServiceOrderCard({
    super.key,
    required this.statusColor,
    required this.statusName,
    required this.price,
    required this.time,
    required this.id,
    this.isFinished = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingDetailsPage(
              id: id,
              price: price,
              isFinished: isFinished,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.fieldBorder,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1, color: AppTheme.hintColor),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: Text(
                        statusName,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: AppTheme.labelColor,
                        ),
                      ),
                    ),
                  ),

                  Text(
                    id,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppTheme.labelColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    time,
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
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: AppTheme.primaryColor,
                        ),
                      ),

                      const SizedBox(width: 5),

                      Text(
                        price,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // يظهر فقط لو الطلب منتهي
              if (isFinished) ...[
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // افتح شاشة التقييم هنا
                      },
                      child: const Text(
                        "< اضافة تقييم",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xff2D9EC4),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
