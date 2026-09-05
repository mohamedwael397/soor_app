import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soor_app/core/const/constans.dart';
import 'package:soor_app/features/bookings/data/models/booking_model.dart';
import 'package:soor_app/features/Chat/cahtScreen.dart';

class BookingDetailsPage extends StatelessWidget {
  final BookingModel booking;
  const BookingDetailsPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final price = booking.totalPrice ?? booking.price ?? '0';
    final isFinished = booking.isFinished == true;
    return Scaffold(
      backgroundColor: const Color(0xff1C1C1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text("#${booking.id}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(onTap: () => Navigator.pop(context), child: Container(decoration: const BoxDecoration(color: AppTheme.fieldBorder, shape: BoxShape.circle), child: const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.arrow_back, color: Colors.white)))),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: () {
                // UI فقط — يفتح الشات Mock مباشرة
                Navigator.push(context, MaterialPageRoute(builder: (_) => Cahtscreen(roomId: booking.id, bookingId: booking.id, peerName: 'حارس #${booking.id}')));
              },
              child: CircleAvatar(backgroundColor: const Color(0xff2D9EC4), child: SvgPicture.asset("assets/images/message-dots-circle.svg", width: 20, height: 20)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          _card(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("$price ريال", style: const TextStyle(color: Color(0xffE8B84B), fontWeight: FontWeight.w700, fontSize: 16)),
                const Text("تفاصيل الحجز", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 14),
              _row("عدد الحراس", "${booking.guardsCount ?? 1} أفراد", "وقت و تاريخ بدء الحجز"),
              const SizedBox(height: 6),
              _row("", booking.startDatetime ?? booking.createdAt ?? '-', ""),
              if (booking.city != null) ...[
                const SizedBox(height: 8),
                _row("المدينة", booking.city!, "المنطقة"),
                const SizedBox(height: 4),
                _row("", booking.areaName ?? '-', ""),
              ],
              if (booking.address != null) ...[
                const SizedBox(height: 8),
                Row(children: [Icon(Icons.location_on, size: 14, color: Colors.white38), const SizedBox(width: 4), Expanded(child: Text(booking.address!, style: const TextStyle(color: Colors.white54, fontSize: 12), textAlign: TextAlign.right))]),
              ],
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0xffE07B2A), borderRadius: BorderRadius.circular(20)), child: Text(booking.statusName ?? booking.status ?? 'قيد الانتظار', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600))),
                const Row(children: [Text("عرض المزيد", style: TextStyle(color: Colors.white70, fontSize: 13)), Icon(Icons.keyboard_arrow_down, color: Colors.white70, size: 18)]),
              ]),
            ]),
          ),
          const SizedBox(height: 14),
          _card(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("طرق الدفع", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)), Row(children: [Text(booking.paymentMethod ?? 'cash', style: const TextStyle(color: Colors.white54)), const SizedBox(width: 8), SvgPicture.asset("assets/images/Content.svg", width: 36, height: 20)])])),
          const SizedBox(height: 14),
          _card(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const Text("ملخص الدفع", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              _summary("قيمة الطلب", "${booking.price ?? price} ريال"),
              const SizedBox(height: 8),
              _summary("رسوم الخدمة", "0 ريال"),
              const SizedBox(height: 5),
              _summary("الاجمالي", "$price ريال", isTotal: true),
            ]),
          ),
          const SizedBox(height: 14),
          _card(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const Text("متابعة الطلب", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              _step("قبول الحارس", "بانتظار موافقة الحارس", done: true),
              _step("وصول الحارس", "الحارس في الطريق", active: !isFinished),
              _step("تم الانتهاء", "اكتملت الخدمة", isLast: true, done: isFinished),
            ]),
          ),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: isFinished ? () => _rate(context) : null,
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white24), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: Text("تقييم", style: TextStyle(color: isFinished ? Colors.white : Colors.white38)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('مد وقت إضافي - UI فقط'))),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text("مد وقت اضافي", style: TextStyle(color: Color(0xffE07B2A), fontWeight: FontWeight.w700)),
              ),
            ),
          ]),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  void _rate(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: AppTheme.fieldBackground,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _MockRateSheet(bookingId: booking.id),
    );
  }

  Widget _card({required Widget child}) => Container(width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xff2A2A2C), borderRadius: BorderRadius.circular(16)), child: child);
  Widget _row(String l1, String v, String l2) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(v, style: const TextStyle(color: Colors.white70, fontSize: 13)), Text(l2, style: const TextStyle(color: Colors.white70, fontSize: 13))]);
  Widget _summary(String l, String v, {bool isTotal = false}) {
    final s = TextStyle(color: isTotal ? const Color(0xffE8B84B) : Colors.white70, fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400, fontSize: isTotal ? 15 : 13);
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(v, style: s), Text(l, style: s)]);
  }

  Widget _step(String title, String sub, {bool done = false, bool active = false, bool isLast = false}) {
    final c = done || active ? const Color(0xff2D9EC4) : Colors.white24;
    return IntrinsicHeight(
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(children: [
          Container(width: 22, height: 22, decoration: BoxDecoration(color: done ? c : Colors.transparent, shape: BoxShape.circle, border: Border.all(color: c, width: 2)), child: done ? const Icon(Icons.check, size: 14, color: Colors.white) : active ? Center(child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle))) : null),
          if (!isLast) Expanded(child: Container(width: 2, color: Colors.white24)),
        ]),
        const SizedBox(width: 12),
        Expanded(child: Padding(padding: const EdgeInsets.only(bottom: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(color: done || active ? Colors.white : Colors.white38, fontWeight: FontWeight.w600, fontSize: 14)), const SizedBox(height: 2), Text(sub, style: const TextStyle(color: Colors.white38, fontSize: 12))]))),
      ]),
    );
  }
}

class _MockRateSheet extends StatefulWidget {
  final int bookingId;
  const _MockRateSheet({required this.bookingId});
  @override
  State<_MockRateSheet> createState() => _MockRateSheetState();
}

class _MockRateSheetState extends State<_MockRateSheet> {
  final criteria = ['الالتزام بالموعد', 'المظهر العام', 'التعامل والأخلاق'];
  final ratings = [5, 5, 5];
  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.hintColor, borderRadius: BorderRadius.circular(8))),
            const SizedBox(height: 12),
            const Text('تقييم الحارس', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            Text('حجز #${widget.bookingId}', style: TextStyle(color: AppTheme.hintColor, fontSize: 12)),
            const SizedBox(height: 16),
            ...List.generate(criteria.length, (i) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: List.generate(5, (s) => GestureDetector(onTap: () => setState(() => ratings[i] = s + 1), child: Icon(Icons.star, size: 26, color: ratings[i] > s ? const Color(0xffffb31a) : Colors.grey.shade800)))), Text(criteria[i], style: const TextStyle(color: Colors.white70))]))),
            const SizedBox(height: 8),
            SizedBox(width: double.infinity, height: 48, child: ElevatedButton(onPressed: () { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال التقييم ✓ - UI فقط'), backgroundColor: Colors.green)); }, style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('إرسال التقييم', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
            const SizedBox(height: 8),
          ]),
        ),
      );
}
