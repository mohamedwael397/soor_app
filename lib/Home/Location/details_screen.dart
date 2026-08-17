import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:soor_app/conistans/constans.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

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

  final TextEditingController notesController = TextEditingController();

  // ================= DATE PICKER =================

  Future<void> displayShowPicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: AppTheme.fieldBackground,
              onSurface: AppTheme.labelColor,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: AppTheme.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // ================= TIME PICKER =================

  Future<void> pickStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: AppTheme.fieldBackground,
              onSurface: AppTheme.labelColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        startTime = picked;
      });
    }
  }

  Future<void> pickEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: AppTheme.fieldBackground,
              onSurface: AppTheme.labelColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        endTime = picked;
      });
    }
  }

  // ================= TIME FORMAT =================

  String formatTime(TimeOfDay? time) {
    if (time == null) return 'اختار الوقت';

    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;

    final minute = time.minute.toString().padLeft(2, '0');

    final period = time.period == DayPeriod.am ? 'ص' : 'م';

    return '$hour:$minute $period';
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: AppTheme.fieldBackground,
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.fieldBorder,
              ),
              child: Icon(Icons.arrow_back, color: AppTheme.labelColor),
            ),
          ),
        ),

        centerTitle: true,

        title: Text(
          'التفاصيل',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.labelColor,
          ),
        ),
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),

        padding: const EdgeInsets.all(10),

        child: Column(
          children: [
            // ================= BOOKING DETAILS =================
            _buildSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _sectionTitle('تفاصيل الحجز'),

                  const SizedBox(height: 18),

                  _label('وقت و تاريخ بدء الحجز'),

                  const SizedBox(height: 10),
                  // DATE
                  _buildDatePicker(),
                  const SizedBox(height: 15),

                  // TIME
                  Row(
                    children: [
                      Expanded(
                        child: _buildTimePicker(
                          title: 'وقت الانتهاء',
                          time: endTime,
                          onTap: pickEndTime,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: _buildTimePicker(
                          title: 'وقت البداية',
                          time: startTime,
                          onTap: pickStartTime,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // ================= ADDITIONAL DETAILS =================
            _buildSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _sectionTitle('تفاصيل إضافية'),

                  const SizedBox(height: 18),

                  _label('نوع اللبس'),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      _buildChoiceChip('كاجول', selectedDress == 'كاجول', () {
                        setState(() {
                          selectedDress = 'كاجول';
                        });
                      }),

                      const SizedBox(width: 6),

                      _buildChoiceChip(
                        'فول سوت',
                        selectedDress == 'فول سوت',
                        () {
                          setState(() {
                            selectedDress = 'فول سوت';
                          });
                        },
                      ),

                      const SizedBox(width: 6),

                      _buildChoiceChip('رسمي', selectedDress == 'رسمي', () {
                        setState(() {
                          selectedDress = 'رسمي';
                        });
                      }),
                    ],
                  ),

                  const SizedBox(height: 18),

                  _label('اللغة المطلوبة'),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      _buildChoiceChip(
                        'English',
                        selectedLang == 'English',
                        () {
                          setState(() {
                            selectedLang = 'English';
                          });
                        },
                      ),

                      const SizedBox(width: 6),

                      _buildChoiceChip('عربي', selectedLang == 'عربي', () {
                        setState(() {
                          selectedLang = 'عربي';
                        });
                      }),
                    ],
                  ),

                  const SizedBox(height: 18),

                  _label('هل يوجد منسق من طرفك'),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      _buildChoiceChip('لا', selectedCoordinator == 'لا', () {
                        setState(() {
                          selectedCoordinator = 'لا';
                        });
                      }),

                      const SizedBox(width: 6),

                      _buildChoiceChip('نعم', selectedCoordinator == 'نعم', () {
                        setState(() {
                          selectedCoordinator = 'نعم';
                        });
                      }),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // ================= NOTES =================
            _buildSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _sectionTitle('ملاحظات إضافية'),

                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,

                    decoration: BoxDecoration(
                      color: AppTheme.fieldBorder,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.hintColor),
                    ),

                    child: TextField(
                      controller: notesController,
                      maxLines: 5,

                      textAlign: TextAlign.right,

                      style: TextStyle(
                        color: AppTheme.labelColor,
                        fontSize: 14,
                      ),

                      decoration: InputDecoration(
                        hintText: 'ملاحظات إضافية هنا...',

                        hintStyle: TextStyle(
                          color: AppTheme.hintColor,
                          fontSize: 14,
                        ),

                        border: InputBorder.none,

                        contentPadding: const EdgeInsets.all(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= ORDER BUTTON =================
            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton(
                onPressed: () {
                  // هنا بعدين هتبعت البيانات للـ backend

                  print('Date: $selectedDate');
                  print('Start: $startTime');
                  print('End: $endTime');
                  print('Dress: $selectedDress');
                  print('Language: $selectedLang');
                  print('Coordinator: $selectedCoordinator');
                  print('Notes: ${notesController.text}');
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,

                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),

                child: Text(
                  '( 1500 ريال ) طلب',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // SECTION
  // =========================================================

  Widget _buildSection({required Widget child}) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: AppTheme.fieldBackground,

        borderRadius: BorderRadius.circular(15),

        border: Border.all(color: AppTheme.fieldBorder, width: 1),
      ),

      child: child,
    );
  }

  // =========================================================
  // SECTION TITLE
  // =========================================================

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 15,
        color: AppTheme.hintColor,
      ),
    );
  }

  // =========================================================
  // LABEL
  // =========================================================

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: AppTheme.labelColor,
      ),
    );
  }

  // =========================================================
  // DATE PICKER
  // =========================================================

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: displayShowPicker,

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),

        decoration: BoxDecoration(
          color: AppTheme.fieldBorder,

          borderRadius: BorderRadius.circular(10),

          border: Border.all(color: AppTheme.hintColor),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            SvgPicture.asset(
              'assets/images/Frame63.svg',
              width: 24,
              height: 24,
            ),

            Text(
              selectedDate == null
                  ? 'إدخل تاريخ الحجز'
                  : DateFormat('yyyy/MM/dd').format(selectedDate!),

              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: selectedDate == null
                    ? AppTheme.hintColor
                    : AppTheme.labelColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // TIME PICKER
  // =========================================================

  Widget _buildTimePicker({
    required String title,
    required TimeOfDay? time,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: AppTheme.fieldBorder,

          borderRadius: BorderRadius.circular(10),

          border: Border.all(color: AppTheme.hintColor),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,

          children: [
            Text(
              title,
              style: TextStyle(color: AppTheme.hintColor, fontSize: 12),
            ),

            const SizedBox(height: 5),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,

              children: [
                Icon(Icons.access_time, size: 18, color: AppTheme.labelColor),

                const SizedBox(width: 5),

                Text(
                  formatTime(time),
                  style: TextStyle(
                    color: AppTheme.labelColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================
// CHOICE CHIP
// =========================================================

Widget _buildChoiceChip(String label, bool isSelected, VoidCallback onTap) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),

        padding: const EdgeInsets.symmetric(vertical: 10),

        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,

          borderRadius: BorderRadius.circular(20),

          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.fieldBorder,
          ),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            if (isSelected) ...[
              const Icon(Icons.check, color: Colors.white, size: 16),

              const SizedBox(width: 4),
            ],

            Text(
              label,

              style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.labelColor,

                fontWeight: FontWeight.w500,

                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
