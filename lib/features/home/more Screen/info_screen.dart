import 'package:flutter/material.dart';
import 'package:soor_app/conistans/constans.dart';

/// شاشة "الشروط والأحكام" لتطبيق سور Soor
class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppTheme.background,
          body: SafeArea(
            child: Column(
              children: [
                Header(
                  titleColor: AppTheme.labelColor,
                  buttonBg: AppTheme.fieldBackground,
                  buttonBorder: AppColors.indicator,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Paragraph(
                          text:
                              'مرحبًا بك في تطبيق "سور Soor". باستخدامك للتطبيق، فإنك '
                              'توافق على الالتزام بهذه الشروط والأحكام. يُرجى قراءة هذه '
                              'الشروط بعناية قبل استخدام خدماتنا.\n'
                              'يُعتبر استخدامك للتطبيق أو تسجيلك فيه قبولًا تامًا لجميع '
                              'بنود هذه الشروط.',
                          color: AppTheme.hintColor,
                        ),
                        const SizedBox(height: 28),
                        ..._sections.map(
                          (s) => _Section(
                            title: s.title,
                            items: s.items,
                            titleColor: AppTheme.labelColor,
                            bodyColor: AppTheme.hintColor,
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
      ),
    );
  }

  static final List<_SectionData> _sections = [
    _SectionData('2. تعريفات', [
      'التطبيق: تطبيق "سور Soor" المخصص لتقديم خدمات حجز البودي جارد والحراسة الشخصية.',
      'المستخدم: أي شخص يقوم بتحميل التطبيق أو التسجيل فيه أو استخدام خدماته.',
      'مقدم الخدمة: أي فرد أو شركة مسجلة داخل التطبيق لتقديم خدمات الحراسة الشخصية.',
      'الإدارة: فريق تطبيق "سور Soor" المسؤول عن تشغيل التطبيق وإدارته.',
    ]),
    _SectionData('3. استخدام التطبيق', [
      'يجب أن يكون عمر المستخدم 18 سنة على الأقل لاستخدام خدمات "سور Soor".',
      'يلتزم المستخدم بتقديم بيانات صحيحة ودقيقة عند التسجيل.',
      'يُمنع استخدام التطبيق لأي غرض غير قانوني أو مخالف للآداب العامة.',
      'يحتفظ التطبيق بالحق في إيقاف أو حذف الحساب في حال مخالفة أي من هذه الشروط.',
    ]),
    _SectionData('4. الخدمات', [
      'يقوم التطبيق بربط العملاء بمقدمي خدمة البودي جارد حسب التوفر والموقع.',
      'التطبيق وسيط فقط ولا يتحمل مسؤولية مباشرة عن تصرفات مقدمي الخدمة أثناء العمل.',
      'يتحمل مقدم الخدمة المسؤولية الكاملة عن أدائه، مظهره، وسلامة السلوك المهني أثناء فترة التعاقد.',
    ]),
    _SectionData('5. الدفع والاسترجاع', [
      'يتم الدفع مقابل الخدمات من خلال الوسائل المعتمدة داخل التطبيق.',
      'قد يتم خصم رسوم الخدمة أو رسوم الإلغاء وفقًا لسياسة التطبيق.',
      'لا يتم استرجاع المبالغ إلا في الحالات التي تقررها الإدارة بعد مراجعة الطلب.',
    ]),
    _SectionData('6. المسؤولية القانونية', [
      'تطبيق "سور Soor" غير مسؤول عن أي أضرار أو خسائر تنتج عن سوء استخدام الخدمة من قبل المستخدم أو مقدم الخدمة.',
      'المستخدم مسؤول مسؤولية كاملة عن أي تعامل أو اتفاق يتم خارج إطار التطبيق.',
    ]),
    _SectionData('7. الخصوصية', [
      'يحترم تطبيق "سور Soor" خصوصية المستخدمين ويحافظ على سرية البيانات.',
      'لمزيد من التفاصيل، يُرجى الاطلاع على سياسة الخصوصية الخاصة بالتطبيق.',
    ]),
    _SectionData('8. التعديلات على الشروط', [
      'يحتفظ تطبيق "سور Soor" بالحق في تعديل هذه الشروط في أي وقت.',
      'يتم إخطار المستخدمين عند إجراء تغييرات جوهرية، ويعتبر استمرار استخدام التطبيق '
          'بعد التعديل موافقة ضمنية على الشروط الجديدة.',
    ]),
  ];
}

class _SectionData {
  final String title;
  final List<String> items;
  const _SectionData(this.title, this.items);
}

class Header extends StatelessWidget {
  final Color titleColor;
  final Color buttonBg;
  final Color buttonBorder;

  const Header({
    required this.titleColor,
    required this.buttonBg,
    required this.buttonBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: buttonBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: buttonBorder),
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            'الشروط و الاحكام',
            style: TextStyle(
              color: titleColor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  final String text;
  final Color color;

  const _Paragraph({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.right,
      style: TextStyle(color: color, fontSize: 14.5, height: 1.7),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<String> items;
  final Color titleColor;
  final Color bodyColor;

  const _Section({
    required this.title,
    required this.items,
    required this.titleColor,
    required this.bodyColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: titleColor,
              fontSize: 16.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) => _BulletItem(text: item, color: bodyColor)),
        ],
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  final Color color;

  const _BulletItem({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.right,
              style: TextStyle(color: color, fontSize: 14.5, height: 1.7),
            ),
          ),
        ],
      ),
    );
  }
}
