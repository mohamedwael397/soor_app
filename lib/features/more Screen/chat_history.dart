import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:soor_app/core/const/constans.dart';
import 'package:soor_app/features/Chat/cahtScreen.dart';

class ChatHistory extends StatefulWidget {
  const ChatHistory({super.key});
  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  final searchCtrl = TextEditingController();
  String query = '';

  // Mock شات UI فقط — هتظبط الـ API بعدين
  final List<Map<String, dynamic>> chats = [
    {'id': 1, 'bookingId': 12336455, 'name': 'أحمد - حارس', 'last': 'انتظرك في الموعد إن شاء الله', 'time': '09:15', 'unread': 2, 'online': true},
    {'id': 2, 'bookingId': 12336456, 'name': 'Soor - الدعم', 'last': 'تم تأكيد حجزك بنجاح ✓', 'time': 'أمس', 'unread': 0, 'online': false},
    {'id': 3, 'bookingId': 12336457, 'name': 'محمد - حارس', 'last': 'وصلت للموقع', 'time': '13:47', 'unread': 0, 'online': true},
    {'id': 4, 'bookingId': 12336458, 'name': 'خالد - منسق', 'last': 'شكراً لتواصلك', 'time': 'الأحد', 'unread': 5, 'online': false},
    {'id': 5, 'bookingId': 12336459, 'name': 'Soor - الفعاليات', 'last': 'خدمة ممتازة 👌', 'time': '10:30', 'unread': 1, 'online': true},
  ];

  @override
  void initState() {
    super.initState();
    searchCtrl.addListener(() => setState(() => query = searchCtrl.text.trim()));
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = chats.where((c) => query.isEmpty || (c['name'] as String).contains(query) || (c['last'] as String).contains(query)).toList();
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.fieldBackground,
        leading: Padding(padding: const EdgeInsets.all(8), child: _CircleBtn(icon: Icons.arrow_back, onTap: () => Navigator.pop(context))),
        title: const Text('المحادثات', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: [
          Padding(padding: const EdgeInsets.all(8), child: _CircleBtn(icon: Icons.more_vert, onTap: () {})),
        ],
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: searchCtrl,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'ابحث في المحادثات...',
                hintStyle: TextStyle(color: AppTheme.hintColor, fontSize: 13),
                prefixIcon: Icon(Icons.search, color: AppTheme.hintColor),
                suffixIcon: query.isNotEmpty ? IconButton(icon: Icon(Icons.clear, color: AppTheme.hintColor, size: 18), onPressed: () => searchCtrl.clear()) : null,
                filled: true,
                fillColor: AppTheme.fieldBackground,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.fieldBorder)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.fieldBorder)),
              ),
            ),
          ),
          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              _TabChip(label: 'الكل', count: chats.length, selected: true),
              const SizedBox(width: 8),
              _TabChip(label: 'غير مقروءة', count: chats.where((c) => c['unread'] > 0).length, selected: false),
            ]),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filtered.isEmpty
                ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.chat_bubble_outline, size: 48, color: AppTheme.hintColor), const SizedBox(height: 12), Text('لا توجد نتائج لـ "$query"', style: TextStyle(color: AppTheme.hintColor))]))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final c = filtered[i];
                      return _ChatTile(
                        name: c['name'],
                        lastMessage: c['last'],
                        time: c['time'],
                        unreadCount: c['unread'],
                        online: c['online'],
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Cahtscreen(roomId: c['id'], bookingId: c['bookingId'], peerName: c['name']))),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('بدء محادثة جديدة - UI فقط'))),
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => Material(color: AppTheme.fieldBorder, shape: const CircleBorder(), child: InkWell(onTap: onTap, customBorder: const CircleBorder(), child: SizedBox(width: 36, height: 36, child: Icon(icon, color: Colors.white, size: 18))));
}

class _TabChip extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  const _TabChip({required this.label, required this.count, required this.selected});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: selected ? AppTheme.primaryColor : AppTheme.fieldBackground, borderRadius: BorderRadius.circular(20), border: Border.all(color: selected ? AppTheme.primaryColor : AppTheme.fieldBorder)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(label, style: TextStyle(color: selected ? Colors.white : AppTheme.hintColor, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(width: 6),
          Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: selected ? Colors.white : AppTheme.fieldBorder, borderRadius: BorderRadius.circular(10)), child: Text('$count', style: TextStyle(color: selected ? AppTheme.primaryColor : AppTheme.hintColor, fontSize: 11, fontWeight: FontWeight.w700))),
        ]),
      );
}

class _ChatTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool online;
  final VoidCallback onTap;
  const _ChatTile({required this.name, required this.lastMessage, required this.time, required this.unreadCount, required this.online, required this.onTap});
  static const _gold = Color(0xFFD3A24C);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF1E1E1E),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Stack(children: [
              CircleAvatar(radius: 24, backgroundColor: AppTheme.fieldBackground, child: SvgPicture.asset("assets/images/Group.svg", width: 26, height: 26)),
              if (online) Positioned(bottom: 0, right: 0, child: Container(width: 12, height: 12, decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: const Color(0xFF1E1E1E), width: 2)))),
            ]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(name, style: const TextStyle(color: _gold, fontSize: 14, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
                  if (unreadCount > 0) Container(constraints: const BoxConstraints(minWidth: 20, minHeight: 20), padding: const EdgeInsets.symmetric(horizontal: 6), alignment: Alignment.center, decoration: BoxDecoration(color: const Color(0xFFE23B3B), borderRadius: BorderRadius.circular(10)), child: Text('$unreadCount', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
                ]),
                const SizedBox(height: 4),
                Text(lastMessage, style: TextStyle(color: unreadCount > 0 ? Colors.white : Colors.white70, fontSize: 13, fontWeight: unreadCount > 0 ? FontWeight.w600 : FontWeight.w400), maxLines: 1, overflow: TextOverflow.ellipsis),
              ]),
            ),
            const SizedBox(width: 8),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(time, style: const TextStyle(color: Colors.white38, fontSize: 11)),
              const SizedBox(height: 6),
              Icon(unreadCount > 0 ? Icons.done : Icons.done_all_rounded, size: 16, color: unreadCount > 0 ? Colors.white38 : _gold),
            ]),
          ]),
        ),
      ),
    );
  }
}
