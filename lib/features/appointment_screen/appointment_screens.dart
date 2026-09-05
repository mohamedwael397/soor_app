import 'package:flutter/material.dart';
import 'package:soor_app/core/const/constans.dart';
import 'package:soor_app/features/booking_details/booking_details_screen.dart';
import 'package:soor_app/features/bookings/data/models/booking_model.dart';

class AppointmentScreens extends StatefulWidget {
  const AppointmentScreens({super.key});
  @override
  State<AppointmentScreens> createState() => _AppointmentScreensState();
}

class _AppointmentScreensState extends State<AppointmentScreens> {
  int selectedFilter = 0;
  final searchCtrl = TextEditingController();
  String searchQuery = '';

  final filters = ['الكل', 'قيد الانتظار', 'قيد التنفيذ', 'منتهي', 'ملغي'];

  // Mock حجوزات UI فقط — هتظبط الـ API بعدين
  late List<BookingModel> allBookings;

  @override
  void initState() {
    super.initState();
    allBookings = [
      BookingModel(id: 12336455, status: 'قبول الحارس', statusName: 'قبول الحارس', price: '1600', totalPrice: '1600', startDatetime: 'اليوم 8:00 م الى 11:00 م', guardsCount: 3, serviceName: 'طلب فرد - حارس شخصي', city: 'الرياض', address: 'حي العليا - برج 1', isFinished: false, createdAt: '2026-09-05 20:00:00'),
      BookingModel(id: 12336456, status: 'قيد التنفيذ', statusName: 'قيد التنفيذ', price: '2400', totalPrice: '2400', startDatetime: 'غداً 6:00 م الى 10:00 م', guardsCount: 2, serviceName: 'طلب شركة - مناسبة', city: 'جدة', address: 'حي الحمراء', isFinished: false, createdAt: '2026-09-06 18:00:00'),
      BookingModel(id: 12336457, status: 'منتهي', statusName: 'منتهي', price: '1800', totalPrice: '1800', startDatetime: 'أمس 7:00 م الى 10:00 م', guardsCount: 1, serviceName: 'طلب فرد', city: 'الرياض', address: 'حي الملقا', isFinished: true, createdAt: '2026-09-04 19:00:00'),
      BookingModel(id: 12336458, status: 'ملغي', statusName: 'ملغي', price: '900', totalPrice: '900', startDatetime: '2026/09/10 2:00 م', guardsCount: 2, serviceName: 'طلب فرد', city: 'الدمام', address: 'حي الشاطئ', isFinished: false, createdAt: '2026-09-10 14:00:00'),
      BookingModel(id: 12336459, status: 'قبول الحارس', statusName: 'قبول الحارس', price: '3200', totalPrice: '3200', startDatetime: 'الخميس 9:00 م الى 2:00 ص', guardsCount: 4, serviceName: 'تأمين فعالية', city: 'الرياض', address: 'قاعة النخيل', isFinished: false, createdAt: '2026-09-07 21:00:00'),
      BookingModel(id: 12336460, status: 'منتهي', statusName: 'منتهي', price: '2100', totalPrice: '2100', startDatetime: '2026/09/02 5:00 م الى 9:00 م', guardsCount: 2, serviceName: 'طلب شركة', city: 'مكة', address: 'حي العزيزية', isFinished: true, createdAt: '2026-09-02 17:00:00'),
    ];
    searchCtrl.addListener(() => setState(() => searchQuery = searchCtrl.text.trim()));
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  Color _statusColor(String? status) {
    final s = (status ?? '').toLowerCase();
    if (s.contains('منتهي') || s.contains('finished') || s.contains('completed')) return const Color(0xff039855);
    if (s.contains('قيد التنفيذ') || s.contains('progress')) return const Color(0xffDC6803);
    if (s.contains('قبول') || s.contains('accepted')) return const Color(0xff00394C);
    if (s.contains('ملغي') || s.contains('cancel')) return const Color(0xffB42318);
    if (s.contains('انتظار') || s.contains('pending')) return const Color(0xff6941C6);
    return const Color(0xff00394C);
  }

  IconData _statusIcon(String? status) {
    final s = (status ?? '');
    if (s.contains('منتهي')) return Icons.check_circle;
    if (s.contains('قيد التنفيذ')) return Icons.timelapse;
    if (s.contains('قبول')) return Icons.verified_user;
    if (s.contains('ملغي')) return Icons.cancel;
    return Icons.hourglass_top;
  }

  List<BookingModel> get filtered {
    var list = allBookings;
    if (selectedFilter != 0) {
      final f = filters[selectedFilter];
      list = list.where((b) => (b.statusName ?? b.status ?? '') == f).toList();
    }
    if (searchQuery.isNotEmpty) {
      list = list.where((b) => '#${b.id}'.contains(searchQuery) || (b.serviceName ?? '').contains(searchQuery) || (b.city ?? '').contains(searchQuery)).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final list = filtered;
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.fieldBackground,
        title: const Text("الحجوزات", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: AppTheme.labelColor)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: CircleAvatar(backgroundColor: AppTheme.fieldBorder, child: IconButton(icon: const Icon(Icons.filter_list, color: Colors.white70, size: 20), onPressed: () {})),
          )
        ],
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: TextField(
              controller: searchCtrl,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'ابحث برقم الحجز أو الخدمة...',
                hintStyle: TextStyle(color: AppTheme.hintColor, fontSize: 13),
                prefixIcon: Icon(Icons.search, color: AppTheme.hintColor),
                suffixIcon: searchQuery.isNotEmpty ? IconButton(icon: Icon(Icons.clear, color: AppTheme.hintColor, size: 18), onPressed: () => searchCtrl.clear()) : null,
                filled: true,
                fillColor: AppTheme.fieldBackground,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.fieldBorder)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.fieldBorder)),
              ),
            ),
          ),
          // Filters
          SizedBox(
            height: 42,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemCount: filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final sel = selectedFilter == i;
                return ChoiceChip(
                  label: Text(filters[i], style: TextStyle(color: sel ? Colors.white : AppTheme.hintColor, fontWeight: sel ? FontWeight.w700 : FontWeight.w400, fontSize: 13)),
                  selected: sel,
                  onSelected: (_) => setState(() => selectedFilter = i),
                  selectedColor: AppTheme.primaryColor,
                  backgroundColor: AppTheme.fieldBackground,
                  side: BorderSide(color: sel ? AppTheme.primaryColor : AppTheme.fieldBorder),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  showCheckmark: false,
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('${list.length} حجز', style: TextStyle(color: AppTheme.hintColor, fontSize: 12)),
              Text('اسحب للتحديث', style: TextStyle(color: AppTheme.hintColor.withValues(alpha: 0.6), fontSize: 11)),
            ]),
          ),
          const SizedBox(height: 8),
          // List
          Expanded(
            child: list.isEmpty
                ? _emptyState()
                : RefreshIndicator(
                    color: AppTheme.primaryColor,
                    onRefresh: () async => await Future.delayed(const Duration(milliseconds: 700)),
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final b = list[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _BookingCard(
                            booking: b,
                            statusColor: _statusColor(b.statusName ?? b.status),
                            statusIcon: _statusIcon(b.statusName ?? b.status),
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookingDetailsPage(booking: b))),
                            onRate: b.isFinished == true ? () => _showRateSheet(b) : null,
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 90, height: 90, decoration: BoxDecoration(color: AppTheme.fieldBackground, shape: BoxShape.circle), child: Icon(Icons.receipt_long, size: 42, color: AppTheme.hintColor)),
          const SizedBox(height: 16),
          const Text('لا يوجد حجوزات', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 8),
          Text('لا يوجد حجوزات تطابق "${filters[selectedFilter]}"', style: TextStyle(color: AppTheme.hintColor, fontSize: 13), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: () => setState(() { selectedFilter = 0; searchCtrl.clear(); }), style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: const Text('عرض الكل', style: TextStyle(color: Colors.white))),
        ]),
      ),
    );
  }

  void _showRateSheet(BookingModel b) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.fieldBackground,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _RateSheet(booking: b),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  final Color statusColor;
  final IconData statusIcon;
  final VoidCallback onTap;
  final VoidCallback? onRate;
  const _BookingCard({required this.booking, required this.statusColor, required this.statusIcon, required this.onTap, this.onRate});

  @override
  Widget build(BuildContext context) {
    final isFinished = booking.isFinished == true;
    final isCancelled = (booking.statusName ?? '').contains('ملغي');
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(color: AppTheme.fieldBackground, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppTheme.fieldBorder)),
        child: Column(children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(20)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(statusIcon, size: 14, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(booking.statusName ?? booking.status ?? '', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                ]),
              ),
              Row(children: [
                Text('#${booking.id}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(width: 6),
                Container(width: 6, height: 6, decoration: BoxDecoration(color: isCancelled ? Colors.redAccent : Colors.green, shape: BoxShape.circle)),
              ]),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: [
              // Service row
              Row(children: [
                Container(width: 42, height: 42, decoration: BoxDecoration(color: AppTheme.fieldBorder, borderRadius: BorderRadius.circular(10)), child: Icon(booking.serviceName?.contains('شركة') == true ? Icons.business : Icons.person, color: AppTheme.primaryColor, size: 20)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(booking.serviceName ?? 'خدمة', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13), textAlign: TextAlign.right),
                    const SizedBox(height: 2),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text('${booking.guardsCount ?? 1} أفراد', style: TextStyle(color: AppTheme.hintColor, fontSize: 12)),
                      const SizedBox(width: 4),
                      Icon(Icons.groups, size: 14, color: AppTheme.hintColor),
                    ]),
                  ]),
                ),
              ]),
              const SizedBox(height: 10),
              Divider(color: AppTheme.fieldBorder, height: 1),
              const SizedBox(height: 10),
              // Time + Price
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                  child: Row(children: [
                    Icon(Icons.access_time, size: 14, color: AppTheme.hintColor),
                    const SizedBox(width: 4),
                    Expanded(child: Text(booking.startDatetime ?? '', style: TextStyle(color: AppTheme.hintColor, fontSize: 12), overflow: TextOverflow.ellipsis)),
                  ]),
                ),
                const SizedBox(width: 8),
                Row(children: [
                  const Text('ريال', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(width: 4),
                  Text(booking.totalPrice ?? booking.price ?? '0', style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w800, fontSize: 16)),
                ]),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                Icon(Icons.location_on, size: 14, color: AppTheme.hintColor),
                const SizedBox(width: 4),
                Expanded(child: Text('${booking.city ?? ''} - ${booking.address ?? ''}', style: TextStyle(color: AppTheme.hintColor, fontSize: 11), overflow: TextOverflow.ellipsis, textAlign: TextAlign.right)),
              ]),
              if (isFinished) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: onRate,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xff2D9EC4).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xff2D9EC4).withValues(alpha: 0.3))),
                      child: const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.star, size: 14, color: Color(0xff2D9EC4)),
                        SizedBox(width: 4),
                        Text('إضافة تقييم', style: TextStyle(color: Color(0xff2D9EC4), fontSize: 12, fontWeight: FontWeight.w600)),
                      ]),
                    ),
                  ),
                ),
              ],
            ]),
          ),
        ]),
      ),
    );
  }
}

class _RateSheet extends StatefulWidget {
  final BookingModel booking;
  const _RateSheet({required this.booking});
  @override
  State<_RateSheet> createState() => _RateSheetState();
}

class _RateSheetState extends State<_RateSheet> {
  final criteria = ['الالتزام بالموعد', 'المظهر العام', 'التعامل والأخلاق', 'الاحترافية'];
  final ratings = <int>[5, 5, 5, 5];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.hintColor, borderRadius: BorderRadius.circular(8))),
          const SizedBox(height: 12),
          const Text('تقييم الحارس', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          Text('حجز #${widget.booking.id}', style: TextStyle(color: AppTheme.hintColor, fontSize: 12)),
          const SizedBox(height: 16),
          ...List.generate(criteria.length, (i) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Row(children: List.generate(5, (s) => GestureDetector(onTap: () => setState(() => ratings[i] = s + 1), child: Icon(Icons.star, size: 26, color: ratings[i] > s ? const Color(0xffffb31a) : Colors.grey.shade800)))),
                  Text(criteria[i], style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ]),
              )),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال التقييم بنجاح ✓'), backgroundColor: Colors.green));
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('إرسال التقييم', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }
}
