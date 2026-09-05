import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:soor_app/core/const/constans.dart';
import 'package:soor_app/core/di/di.dart';
import 'package:soor_app/features/bookings/data/models/booking_model.dart';
import 'package:soor_app/features/bookings/logic/booking_cubit.dart';
import 'package:soor_app/features/bookings/logic/booking_state.dart';

class DetailsScreen extends StatefulWidget {
  final String serviceId;
  final String lat;
  final String long;
  final String areaName;
  final String buildingName;
  final String floor;
  final String addressDetails;
  final String city;
  final String region;
  final String street;
  const DetailsScreen({
    super.key,
    required this.serviceId,
    required this.lat,
    required this.long,
    required this.areaName,
    required this.buildingName,
    required this.floor,
    required this.addressDetails,
    required this.city,
    required this.region,
    required this.street,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String selectedDress = 'رسمي';
  String selectedLang = 'عربي';
  String selectedCoordinator = 'نعم';
  final notesController = TextEditingController();
  final coordNameCtrl = TextEditingController();
  final coordPhoneCtrl = TextEditingController();
  final guardsCtrl = TextEditingController(text: '2');
  String paymentMethod = 'cash';
  String? hourPrice;
  bool _loadingPrice = true;

  late BookingCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<BookingCubit>();
    _loadHourPrice();
  }

  Future<void> _loadHourPrice() async {
    final res = await _cubit.repo.getHourPrice();
    res.fold(
      (l) => setState(() { hourPrice = null; _loadingPrice = false; }),
      (p) => setState(() { hourPrice = p; _loadingPrice = false; }),
    );
  }

  Future<void> displayShowPicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppTheme.primaryColor, onPrimary: Colors.white, surface: AppTheme.fieldBackground, onSurface: AppTheme.labelColor),
          dialogTheme: const DialogThemeData(backgroundColor: AppTheme.background, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25)))),
        ),
        child: child!,
      ),
    );
    if (pickedDate != null) setState(() => selectedDate = pickedDate);
  }

  Future<void> pickStartTime() async {
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.now(), builder: (c, child) => Theme(data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: AppTheme.primaryColor, onPrimary: Colors.white, surface: AppTheme.fieldBackground, onSurface: AppTheme.labelColor)), child: child!));
    if (t != null) setState(() => startTime = t);
  }

  Future<void> pickEndTime() async {
    final t = await showTimePicker(context: context, initialTime: startTime ?? TimeOfDay.now(), builder: (c, child) => Theme(data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: AppTheme.primaryColor, onPrimary: Colors.white, surface: AppTheme.fieldBackground, onSurface: AppTheme.labelColor)), child: child!));
    if (t != null) setState(() => endTime = t);
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return 'اختار الوقت';
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'ص' : 'م';
    return '$hour:$minute $period';
  }

  int _calcDuration() {
    if (startTime == null || endTime == null) return 4;
    final s = startTime!.hour * 60 + startTime!.minute;
    final e = endTime!.hour * 60 + endTime!.minute;
    int diff = e - s;
    if (diff <= 0) diff += 24 * 60;
    int hours = (diff / 60).ceil();
    if (hours < 1) hours = 1;
    if (hours > 24) hours = 24;
    return hours;
  }

  String _dressApi() {
    if (selectedDress == 'رسمي') return 'Formal';
    if (selectedDress == 'كاجول') return 'Casual';
    return 'Full Suit';
  }

  String _langApi() => selectedLang == 'English' ? 'en' : 'ar';

  double _calcTotal() {
    final h = double.tryParse(hourPrice ?? '0') ?? 0;
    final guards = int.tryParse(guardsCtrl.text) ?? 1;
    final dur = _calcDuration();
    if (h == 0) return 0;
    return h * guards * dur;
  }

  Future<void> _submit() async {
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اختر تاريخ الحجز')));
      return;
    }
    if (startTime == null || endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اختر وقت البداية والنهاية')));
      return;
    }
    if (selectedCoordinator == 'نعم' && (coordNameCtrl.text.trim().isEmpty || coordPhoneCtrl.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('أدخل بيانات المنسق')));
      return;
    }
    final guards = int.tryParse(guardsCtrl.text) ?? 0;
    if (guards < 1) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('عدد الحراس يجب أن يكون 1 على الأقل')));
      return;
    }
    final duration = _calcDuration();
    final startDt = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, startTime!.hour, startTime!.minute);
    final startStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(startDt);

    final req = CreateBookingRequest(
      serviceId: widget.serviceId,
      lat: widget.lat,
      long: widget.long,
      areaName: widget.areaName,
      buildingName: widget.buildingName,
      floor: widget.floor,
      addressDetails: widget.addressDetails,
      city: widget.city,
      region: widget.region,
      street: widget.street,
      startDatetime: startStr,
      durationHours: duration.toString(),
      guardsCount: guards.toString(),
      dressType: _dressApi(),
      language: _langApi(),
      hasCoordinator: selectedCoordinator == 'نعم' ? '1' : '0',
      coordinatorName: selectedCoordinator == 'نعم' ? coordNameCtrl.text.trim() : null,
      coordinatorPhone: selectedCoordinator == 'نعم' ? coordPhoneCtrl.text.trim() : null,
      additionalNotes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
      paymentMethod: paymentMethod,
    );

    await _cubit.createBooking(req);
  }

  @override
  void dispose() {
    notesController.dispose();
    coordNameCtrl.dispose();
    coordPhoneCtrl.dispose();
    guardsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingCreated) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.green));
            // عودة للهوم + تبويب الحجوزات
            Navigator.popUntil(context, (r) => r.isFirst);
          } else if (state is BookingCreateError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent));
          }
        },
        child: Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            backgroundColor: AppTheme.fieldBackground,
            elevation: 0,
            leading: Padding(padding: const EdgeInsets.all(8), child: GestureDetector(onTap: () => Navigator.pop(context), child: Container(decoration: const BoxDecoration(shape: BoxShape.circle, color: AppTheme.fieldBorder), child: const Icon(Icons.arrow_back, color: AppTheme.labelColor)))),
            centerTitle: true,
            title: const Text('التفاصيل', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.labelColor)),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              _buildSection(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                _sectionTitle('تفاصيل الحجز'),
                const SizedBox(height: 18),
                _label('وقت و تاريخ بدء الحجز'),
                const SizedBox(height: 10),
                _buildDatePicker(),
                const SizedBox(height: 15),
                Row(children: [
                  Expanded(child: _buildTimePicker(title: 'وقت الانتهاء', time: endTime, onTap: pickEndTime)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildTimePicker(title: 'وقت البداية', time: startTime, onTap: pickStartTime)),
                ]),
                const SizedBox(height: 12),
                _label('عدد الحراس'),
                const SizedBox(height: 8),
                TextField(
                  controller: guardsCtrl,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(filled: true, fillColor: AppTheme.fieldBorder, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppTheme.hintColor)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppTheme.hintColor)), contentPadding: const EdgeInsets.symmetric(vertical: 12)),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 8),
                if (hourPrice != null)
                  Align(alignment: Alignment.centerRight, child: Text('سعر الساعة: $hourPrice ريال  •  المدة: ${_calcDuration()} ساعات  •  الإجمالي التقريبي: ${_calcTotal().toStringAsFixed(0)} ريال', style: const TextStyle(color: AppTheme.hintColor, fontSize: 12))),
                if (_loadingPrice) const Align(alignment: Alignment.centerRight, child: Text('جاري تحميل سعر الساعة...', style: TextStyle(color: AppTheme.hintColor, fontSize: 12))),
              ])),
              const SizedBox(height: 15),
              _buildSection(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                _sectionTitle('تفاصيل إضافية'),
                const SizedBox(height: 18),
                _label('نوع اللبس'),
                const SizedBox(height: 10),
                Row(children: [_buildChoiceChip('كاجول', selectedDress == 'كاجول', () => setState(() => selectedDress = 'كاجول')), const SizedBox(width: 6), _buildChoiceChip('فول سوت', selectedDress == 'فول سوت', () => setState(() => selectedDress = 'فول سوت')), const SizedBox(width: 6), _buildChoiceChip('رسمي', selectedDress == 'رسمي', () => setState(() => selectedDress = 'رسمي'))]),
                const SizedBox(height: 18),
                _label('اللغة المطلوبة'),
                const SizedBox(height: 10),
                Row(children: [_buildChoiceChip('English', selectedLang == 'English', () => setState(() => selectedLang = 'English')), const SizedBox(width: 6), _buildChoiceChip('عربي', selectedLang == 'عربي', () => setState(() => selectedLang = 'عربي'))]),
                const SizedBox(height: 18),
                _label('هل يوجد منسق من طرفك'),
                const SizedBox(height: 10),
                Row(children: [_buildChoiceChip('لا', selectedCoordinator == 'لا', () => setState(() => selectedCoordinator = 'لا')), const SizedBox(width: 6), _buildChoiceChip('نعم', selectedCoordinator == 'نعم', () => setState(() => selectedCoordinator = 'نعم'))]),
                if (selectedCoordinator == 'نعم') ...[
                  const SizedBox(height: 12),
                  TextField(controller: coordNameCtrl, textAlign: TextAlign.right, style: const TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'اسم المنسق', hintStyle: const TextStyle(color: AppTheme.hintColor), filled: true, fillColor: AppTheme.fieldBorder, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none))),
                  const SizedBox(height: 8),
                  TextField(controller: coordPhoneCtrl, keyboardType: TextInputType.phone, textAlign: TextAlign.right, style: const TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'جوال المنسق', hintStyle: const TextStyle(color: AppTheme.hintColor), filled: true, fillColor: AppTheme.fieldBorder, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none))),
                ],
                const SizedBox(height: 18),
                _label('طريقة الدفع'),
                const SizedBox(height: 10),
                Row(children: [_buildChoiceChip('كاش', paymentMethod == 'cash', () => setState(() => paymentMethod = 'cash')), const SizedBox(width: 6), _buildChoiceChip('اونلاين', paymentMethod == 'online', () => setState(() => paymentMethod = 'online'))]),
              ])),
              const SizedBox(height: 15),
              _buildSection(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                _sectionTitle('ملاحظات إضافية'),
                const SizedBox(height: 12),
                Container(width: double.infinity, decoration: BoxDecoration(color: AppTheme.fieldBorder, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.hintColor)), child: TextField(controller: notesController, maxLines: 5, textAlign: TextAlign.right, style: const TextStyle(color: AppTheme.labelColor, fontSize: 14), decoration: const InputDecoration(hintText: 'ملاحظات إضافية هنا...', hintStyle: TextStyle(color: AppTheme.hintColor, fontSize: 14), border: InputBorder.none, contentPadding: EdgeInsets.all(14)))),
              ])),
              const SizedBox(height: 20),
              BlocBuilder<BookingCubit, BookingState>(builder: (context, state) {
                final creating = state is BookingCreating;
                final totalTxt = _calcTotal() > 0 ? '${_calcTotal().toStringAsFixed(0)} ريال' : (hourPrice != null ? '$hourPrice ريال/ساعة' : '1500 ريال');
                return SizedBox(
                  width: double.infinity, height: 52,
                  child: ElevatedButton(
                    onPressed: creating ? null : _submit,
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                    child: creating ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Text('( $totalTxt ) طلب', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                );
              }),
              const SizedBox(height: 20),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required Widget child}) => Container(width: double.infinity, padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: AppTheme.fieldBackground, borderRadius: BorderRadius.circular(15), border: Border.all(color: AppTheme.fieldBorder, width: 1)), child: child);
  Widget _sectionTitle(String t) => Text(t, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: AppTheme.hintColor));
  Widget _label(String t) => Text(t, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: AppTheme.labelColor));
  Widget _buildDatePicker() => GestureDetector(onTap: displayShowPicker, child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), decoration: BoxDecoration(color: AppTheme.fieldBorder, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.hintColor)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [SvgPicture.asset('assets/images/Frame63.svg', width: 24, height: 24), Text(selectedDate == null ? 'إدخل تاريخ الحجز' : DateFormat('yyyy/MM/dd').format(selectedDate!), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: selectedDate == null ? AppTheme.hintColor : AppTheme.labelColor))])) );
  Widget _buildTimePicker({required String title, required TimeOfDay? time, required VoidCallback onTap}) => GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppTheme.fieldBorder, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.hintColor)), child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(title, style: const TextStyle(color: AppTheme.hintColor, fontSize: 12)), const SizedBox(height: 5), Row(mainAxisAlignment: MainAxisAlignment.end, children: [const Icon(Icons.access_time, size: 18, color: AppTheme.labelColor), const SizedBox(width: 5), Text(formatTime(time), style: const TextStyle(color: AppTheme.labelColor, fontSize: 14, fontWeight: FontWeight.w500))])])));
}

Widget _buildChoiceChip(String label, bool isSelected, VoidCallback onTap) => Expanded(child: GestureDetector(onTap: onTap, child: AnimatedContainer(duration: const Duration(milliseconds: 200), padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(color: isSelected ? AppTheme.primaryColor : Colors.transparent, borderRadius: BorderRadius.circular(20), border: Border.all(color: isSelected ? AppTheme.primaryColor : AppTheme.fieldBorder)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [if (isSelected) ...[const Icon(Icons.check, color: Colors.white, size: 16), const SizedBox(width: 4)], Text(label, style: TextStyle(color: isSelected ? Colors.white : AppTheme.labelColor, fontWeight: FontWeight.w500, fontSize: 13))]))));
