import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:soor_app/core/const/constans.dart';
import 'package:soor_app/features/Chat/call_screen.dart';

class Cahtscreen extends StatefulWidget {
  final int? roomId;
  final int? bookingId;
  final String? peerName;
  const Cahtscreen({super.key, this.roomId, this.bookingId, this.peerName});

  @override
  State<Cahtscreen> createState() => _CahtscreenState();
}

class _CahtscreenState extends State<Cahtscreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final FocusNode _focus = FocusNode();

  // Mock شات UI فقط — كل حاجة شغالة لوكال
  late List<Map<String, dynamic>> messages;

  @override
  void initState() {
    super.initState();
    messages = [
      {'text': 'مرحباً، تم تأكيد حجزك #${widget.bookingId ?? 12336455}', 'isMine': false, 'time': _nowMinus(30), 'name': widget.peerName ?? 'Soor'},
      {'text': 'انتظرك في الموعد إن شاء الله', 'isMine': true, 'time': _nowMinus(25), 'name': 'أنت'},
      {'text': 'إن شاء الله أكون موجود في الموعد', 'isMine': false, 'time': _nowMinus(24), 'name': widget.peerName ?? 'Soor'},
      {'text': 'هل تحتاج أي شيء إضافي؟', 'isMine': false, 'time': _nowMinus(10), 'name': widget.peerName ?? 'Soor'},
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  String _nowMinus(int minutes) {
    final dt = DateTime.now().subtract(Duration(minutes: minutes));
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _now() {
    final dt = DateTime.now();
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) _scroll.animateTo(_scroll.position.maxScrollExtent, duration: const Duration(milliseconds: 280), curve: Curves.easeOut);
    });
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => messages.add({'text': text, 'isMine': true, 'time': _now(), 'name': 'أنت'}));
    _controller.clear();
    _scrollToBottom();
    // رد تلقائي mock بعد ثانيتين عشان الشات يبان حي
    Future.delayed(const Duration(seconds: 1200, milliseconds: 200), () {
      if (!mounted) return;
      setState(() => messages.add({'text': 'تم الاستلام 👍', 'isMine': false, 'time': _now(), 'name': widget.peerName ?? 'Soor'}));
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.fieldBackground,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(6),
          child: GestureDetector(onTap: () => Navigator.pop(context), child: Container(decoration: const BoxDecoration(shape: BoxShape.circle, color: AppTheme.fieldBorder), child: const Icon(Icons.arrow_back, color: Colors.white))),
        ),
        title: Row(children: [
          Stack(children: [
            CircleAvatar(radius: 18, backgroundColor: AppTheme.fieldBorder, child: SvgPicture.asset("assets/images/Group.svg", width: 20, height: 20)),
            Positioned(bottom: 0, right: 0, child: Container(width: 10, height: 10, decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: AppTheme.fieldBackground, width: 2)))),
          ]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.peerName ?? 'Soor', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
              const Text('متصل الآن', style: TextStyle(color: Colors.green, fontSize: 11)),
            ]),
          ),
        ]),
        actions: [
          Padding(
            padding: const EdgeInsets.all(6),
            child: GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen())), child: Container(decoration: const BoxDecoration(color: Color(0xff005875), shape: BoxShape.circle), padding: const EdgeInsets.all(10), child: SvgPicture.asset("assets/images/phone-call-01.svg", width: 18, height: 18))),
          ),
        ],
      ),
      body: Column(
        children: [
          // Date separator
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: AppTheme.fieldBackground, borderRadius: BorderRadius.circular(20)),
            child: Text('اليوم', style: TextStyle(color: AppTheme.hintColor, fontSize: 12)),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: messages.length,
              itemBuilder: (context, i) {
                final m = messages[i];
                final isMine = m['isMine'] as bool;
                return _bubble(text: m['text'], isMine: isMine, time: m['time'], name: m['name']);
              },
            ),
          ),
          // Input bar — شكل شات عادي
          SafeArea(
            child: Container(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              decoration: BoxDecoration(color: AppTheme.fieldBackground, border: Border(top: BorderSide(color: AppTheme.fieldBorder))),
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                // Attach
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(color: AppTheme.fieldBorder, borderRadius: BorderRadius.circular(12)),
                  child: IconButton(icon: Icon(Icons.attach_file, color: AppTheme.hintColor, size: 20), onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('المرفقات - UI فقط')))),
                ),
                const SizedBox(width: 8),
                // Text field
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 110),
                    decoration: BoxDecoration(color: AppTheme.fieldBorder, borderRadius: BorderRadius.circular(14)),
                    child: TextField(
                      controller: _controller,
                      focusNode: _focus,
                      maxLines: 5,
                      minLines: 1,
                      textAlign: TextAlign.right,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'رسالتك هنا...',
                        hintStyle: TextStyle(color: AppTheme.hintColor, fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        suffixIcon: IconButton(icon: Icon(Icons.emoji_emotions_outlined, color: AppTheme.hintColor, size: 20), onPressed: () {}),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Send
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(12)),
                  child: IconButton(icon: const Icon(Icons.send, color: Colors.white, size: 18), onPressed: _send),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bubble({required String text, required bool isMine, required String time, required String name}) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isMine ? const Color(0xff202020) : const Color(0xff00394C),
              borderRadius: isMine
                  ? const BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14), bottomLeft: Radius.circular(14))
                  : const BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14), bottomRight: Radius.circular(14)),
              border: Border.all(color: isMine ? Colors.white10 : const Color(0xff005875).withValues(alpha: 0.5)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(name, style: TextStyle(color: isMine ? AppTheme.primaryColor : Colors.white70, fontSize: 11, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(text, textAlign: TextAlign.right, style: TextStyle(color: isMine ? Colors.white : Colors.white, fontSize: 14, height: 1.4)),
            ]),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: EdgeInsets.only(left: isMine ? 0 : 4, right: isMine ? 4 : 0),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(time, style: TextStyle(color: AppTheme.hintColor.withValues(alpha: 0.7), fontSize: 10)),
              const SizedBox(width: 4),
              Icon(isMine ? Icons.done_all : Icons.done, size: 12, color: isMine ? const Color(0xFFD3A24C) : Colors.white24),
            ]),
          ),
        ]),
      ),
    );
  }
}
