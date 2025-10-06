import 'package:e_smartward/Model/chat_model.dart';
import 'package:e_smartward/widget/text.dart';
import 'package:flutter/material.dart';

class ChatDetail extends StatelessWidget {
  final ChatMessage message;
  final void Function(ChatMessage msg, bool isAlert) onSetAlert;
  final String? highlight;
  final bool isHighlighted;

  const ChatDetail({
    Key? key,
    required this.message,
    required this.onSetAlert,
    this.highlight,
    required this.isHighlighted,
  }) : super(key: key);

  static String _formatTime(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> _showContextMenu(BuildContext context, Offset globalPos) async {
    final isAlertNow = (message.type ?? '').toUpperCase() == 'ALERT';

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
          globalPos.dx, globalPos.dy, globalPos.dx, globalPos.dy),
      items: [
        if (!isAlertNow)
          PopupMenuItem(
            value: 'set_alert',
            child: Row(
              children: [
                Icon(Icons.campaign, size: 18),
                SizedBox(width: 8),
                text(context, 'ตั้งเป็นข้อความประกาศ'),
              ],
            ),
          )
        else
          PopupMenuItem(
            value: 'unset_alert',
            child: Row(
              children: [
                Icon(Icons.undo, size: 18),
                SizedBox(width: 8),
                text(context, 'ยกเลิกประกาศ'),
              ],
            ),
          ),
      ],
    );

    if (selected == 'set_alert') {
      onSetAlert(message, true);
    } else if (selected == 'unset_alert') {
      onSetAlert(message, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final isAlert = (message.type ?? '').toUpperCase() == 'ALERT';
    final bg = isAlert
        ? Color.fromARGB(255, 126, 178, 216)
        : (isMe ? Colors.teal : Colors.white);

    final fg = isAlert || isMe ? Colors.white : Colors.black87;

    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(14),
      topRight: const Radius.circular(14),
      bottomLeft: Radius.circular(isMe ? 14 : 4),
      bottomRight: Radius.circular(isMe ? 4 : 14),
    );

    return GestureDetector(
      onLongPressStart: (details) {
        _showContextMenu(context, details.globalPosition);
      },
      child: Column(
        crossAxisAlignment: align,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: radius,
              border: Border.all(
                color: isMe ? Colors.transparent : const Color(0xFFE3E7EB),
              ),
              boxShadow: [
                if (!isMe && !isAlert)
                  BoxShadow(
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                    color: Colors.black.withOpacity(0.04),
                  ),
              ],
            ),
            child: Stack(
              children: [
                if ((message.type ?? '').toUpperCase() == 'AUTO')
                  text(
                    context,
                    message.text,
                    color: Colors.teal,
                    fontSize: 14.5,
                  )
                else
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: text(
                      context,
                      message.text,
                      color: fg,
                      fontSize: 14.5,
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6, right: 6, bottom: 2),
            child: Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                text(context, message.date ?? '',
                    color: Colors.grey.shade500, fontSize: 12),
                const SizedBox(width: 5),
                text(context, message.createByName ?? '',
                    color: Colors.grey.shade500, fontSize: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
