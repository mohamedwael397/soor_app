import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soor_app/core/const/constans.dart';

class BookingDetailsPage extends StatelessWidget {
  final String id;
  final String price;
  final bool isFinished;

  const BookingDetailsPage({
    super.key,
    required this.id,
    required this.price,
    this.isFinished = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1C1C1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "#$id",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.fieldBorder,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_back, color: AppTheme.labelColor),
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: const Color(0xff2D9EC4),
              child: SvgPicture.asset("assets/images/message-dots-circle.svg"),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            sectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$price ريال",
                        style: TextStyle(
                          color: Color(0xffE8B84B),
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "تفاصيل الحجز",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14),
                  detailRow("عدد الحراس", "3 افراد", "وقت و تاريخ بدء الحجز"),
                  SizedBox(height: 6),
                  detailRow("", "260/10/2022  3:00 pm", ""),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffE07B2A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "وصول الحارس",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Row(
                        children: const [
                          Text(
                            "عرض المزيد",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white70,
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 14),

            sectionCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "طرق الدفع",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [SvgPicture.asset("assets/images/Content.svg")],
                  ),
                ],
              ),
            ),

            SizedBox(height: 14),

            sectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "ملخص الدفع",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12),
                  summaryRow("قيمة الطلب", "1500 ريال"),
                  SizedBox(height: 8),
                  summaryRow("رسوم الخدمة", "50 ريال"),
                  SizedBox(height: 5),
                  summaryRow("الاجمالي", "$price ريال", isTotal: true),
                ],
              ),
            ),

            SizedBox(height: 14),

            sectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "متابعة الطلب",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 16),
                  trackingStep("قبول الحارس", "هنا يكتب الوصف", done: true),
                  trackingStep("وصول الحارس", "هنا يكتب الوصف", active: true),
                  trackingStep("تم الانتهاء", "هنا يكتب الوصف", isLast: true),
                ],
              ),
            ),

            SizedBox(height: 20),

            // الأزرار السفلية
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isFinished ? () {} : null,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white24),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "تقييم",
                      style: TextStyle(color: Colors.white38),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // مد وقت إضافي
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "مد وقت اضافي",
                      style: TextStyle(
                        color: Color(0xffE07B2A),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff2A2A2C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget detailRow(String label1, String value, String label2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        Text(
          label2,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }

  Widget summaryRow(String label, String value, {bool isTotal = false}) {
    final style = TextStyle(
      color: isTotal ? const Color(0xffE8B84B) : Colors.white70,
      fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
      fontSize: isTotal ? 15 : 13,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(value, style: style),
        Text(label, style: style),
      ],
    );
  }

  Widget trackingStep(
    String title,
    String subtitle, {
    bool done = false,
    bool active = false,
    bool isLast = false,
  }) {
    final color = done || active ? const Color(0xff2D9EC4) : Colors.white24;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: done ? color : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: done
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : active
                    ? Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
              if (!isLast)
                Expanded(child: Container(width: 2, color: Colors.white24)),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: done || active ? Colors.white : Colors.white38,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
