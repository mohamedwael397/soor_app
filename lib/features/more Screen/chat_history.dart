import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:soor_app/core/const/constans.dart';

class ChatHistory extends StatelessWidget {
  const ChatHistory({super.key});

  static final List<ChatPreview> chats = [
    const ChatPreview(
      name: 'Soor',
      lastMessage: 'خدمة ممتازة',
      time: '13:47',
      unreadCount: 3,
    ),
    const ChatPreview(
      name: 'Soor',
      lastMessage: 'خدمة ممتازة',
      time: '13:47',
      unreadCount: 0,
    ),
    const ChatPreview(
      name: 'Soor',
      lastMessage: 'خدمة ممتازة',
      time: '13:47',
      unreadCount: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.fieldBackground,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleIconButton(
            icon: Icons.arrow_back,
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),

        title: Text(
          'المحادثات',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemCount: chats.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return ChatTile(chat: chats[index], onTap: () {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.fieldBorder,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, color: Colors.white, size: 14),
        ),
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  const ChatTile({required this.chat, required this.onTap});

  final ChatPreview chat;
  final VoidCallback onTap;

  static const _gold = Color(0xFFD3A24C);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF222222),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.fieldBackground,
                child: SvgPicture.asset("assets/images/Group.svg"),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          chat.name,
                          style: const TextStyle(
                            color: _gold,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (chat.unreadCount > 0) ...[
                          const SizedBox(width: 6),
                          _UnreadBadge(count: chat.unreadCount),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chat.lastMessage,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    chat.time,
                    style: const TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                  const SizedBox(height: 8),
                  const Icon(Icons.done_all_rounded, size: 16, color: _gold),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFE23B3B),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}

class ChatPreview {
  const ChatPreview({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
  });

  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
}
