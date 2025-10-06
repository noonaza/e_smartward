// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:e_smartward/widget/chat_detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:e_smartward/Model/chat_model.dart';
import 'package:e_smartward/Model/list_user_model.dart';
import 'package:e_smartward/api/chat_api.dart';
import 'package:e_smartward/widget/text.dart';

class ChatDialog extends StatefulWidget {
  final Map<String, String> headers;
  final String visitId;
  final List<ListUserModel>? lUserLogin;

  const ChatDialog({
    super.key,
    required this.headers,
    required this.visitId,
    this.lUserLogin,
  });

  @override
  State<ChatDialog> createState() => _ChatDialogState();
}

class _ChatDialogState extends State<ChatDialog> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  List<ChatModel> dataAutoChat = [];

  List<ChatMessage> _messages = [];
  bool _loading = true;
  String? _error;
  bool _sending = false;
  bool _alertOpen = false;

  @override
  void initState() {
    super.initState();
    _loadChat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _loadChat() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    dataAutoChat = await ChatApi().loadAutoChat(
      context,
      headers_: widget.headers,
      visitId: widget.visitId,
    );

    final loadedMsgs = dataAutoChat.map((c) {
      final ts =
          DateTime.tryParse(c.create_date?.toString() ?? '') ?? DateTime.now();
      final isMine = (c.create_by == widget.lUserLogin!.first.id);
      return ChatMessage(
          text: c.message ?? '',
          isMe: isMine,
          time: ts,
          id: c.id,
          createByName: c.create_by_name,
          date: c.create_date,
          type: c.type_message);
    }).toList();

    setState(() {
      _messages = loadedMsgs;
      _loading = false;
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send() async {
    if (_sending) return;

    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _sending = true);

    final tempMsg = ChatMessage(
      text: text,
      isMe: true,
      time: DateTime.now(),
      type: 'CHAT',
    );

    setState(() {
      _messages.add(tempMsg);
      _controller.clear();
    });
    _scrollToBottom();

    final newId = await ChatApi().CreateChat(
      context,
      visitId: widget.visitId,
      typeMessage: 'CHAT',
      message: text,
      tlCommonUsersId: widget.lUserLogin!.first.id!,
      headers_: widget.headers,
    );

    if (newId != null) {
      final idx = _messages.lastIndexWhere((m) => identical(m, tempMsg));
      if (idx != -1) {
        setState(() {
          _messages[idx] = _messages[idx].copyWith(id: newId);
        });
      }
    } else {
      setState(() {
        _messages.remove(tempMsg);
        _controller.text = text;
      });
    }

    setState(() => _sending = false);
  }

  bool _showSearch = false;
  final txtSearch = TextEditingController();
  String _query = '';
  final List<int> _hits = [];
  int _hitIndex = 0;
  final Map<int, GlobalKey> _msgKeys = {};

  void showOrHideSearch() {
    setState(() {
      _showSearch = !_showSearch;
      if (!_showSearch) {
        txtSearch.clear();
        SearchChat('');
      }
    });
  }

  void SearchChat(String q) {
    _query = q.trim();
    _hits.clear();
    if (_query.isNotEmpty) {
      for (var i = 0; i < _messages.length; i++) {
        final m = _messages[i];
        final hay = '${m.text} ${m.createByName ?? ''}'.toLowerCase();
        if (hay.contains(_query.toLowerCase())) {
          _hits.add(i);
        }
      }
    }
    _hitIndex = 0;
    setState(() {});
    scrollToSearch();
  }

  void _nextHit() {
    if (_hits.isEmpty) return;
    _hitIndex = (_hitIndex + 1) % _hits.length;
    scrollToSearch();
  }

  void _prevHit() {
    if (_hits.isEmpty) return;
    _hitIndex = (_hitIndex - 1 + _hits.length) % _hits.length;
    scrollToSearch();
  }

  Future<void> scrollToSearch() async {
    if (_hits.isEmpty) return;
    final idx = _hits[_hitIndex];
    final key = _msgKeys[idx];
    if (key?.currentContext != null) {
      await Scrollable.ensureVisible(
        key!.currentContext!,
        alignment: 0.2,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    } else if (_scroll.hasClients) {
      final offset = (idx * 72.0).clamp(0, _scroll.position.maxScrollExtent);
      _scroll.animateTo(
        offset.toDouble(),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> UpdateAlert(ChatMessage msg, bool setAlert) async {
    final oldType = msg.type;
    final newType = setAlert ? 'ALERT' : 'CHAT';
    final idx = _messages.indexWhere((m) => m.id == msg.id);
    if (idx == -1) return;

    setState(() {
      _messages[idx] = _messages[idx].copyWith(type: newType);
    });

    final editedId = await ChatApi().EditChat(
      context,
      headers_: widget.headers,
      id: msg.id!,
      typeMessage: newType,
      message: msg.text,
      tlCommonUsersId: widget.lUserLogin!.first.id!,
    );

    if (editedId == null) {
      setState(() {
        _messages[idx] = _messages[idx].copyWith(type: oldType);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dialogWidth = MediaQuery.of(context).size.width.clamp(450.0, 580.0);
    final dialogHeight = MediaQuery.of(context).size.height.clamp(480.0, 700.0);
    final alerts = _messages
        .where((m) => (m.type ?? '').toUpperCase() == 'ALERT')
        .toList();
    return Dialog(
      elevation: 0,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: dialogWidth, maxHeight: dialogHeight),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              Container(
                height: 56,
                color: Colors.teal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Icon(Icons.chat, color: Colors.white),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'โน๊ตพิเศษ',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    //>> ปุ่มค้นหา <<//
                    IconButton(
                      tooltip: 'ค้นหา',
                      onPressed: showOrHideSearch,
                      icon: const Icon(Icons.search, color: Colors.white),
                    ),
                    IconButton(
                      tooltip: 'ปิด',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),

              //>> แถบค้นหา  <<//
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: _showSearch
                    ? Padding(
                        key: const ValueKey('search-bar'),
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: txtSearch,
                                onChanged: SearchChat,
                                decoration: InputDecoration(
                                  hintText: 'ค้นหาแชท (ข้อความ/ชื่อผู้เขียน)',
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  suffixIcon: (_query.isNotEmpty)
                                      ? IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            txtSearch.clear();
                                            SearchChat('');
                                          },
                                        )
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            text(
                              context,
                              '${_hits.isEmpty ? 0 : _hitIndex + 1}/${_hits.length}',
                            ),
                            IconButton(
                              tooltip: 'ก่อนหน้า',
                              onPressed: _hits.isEmpty ? null : _prevHit,
                              icon: const Icon(Icons.keyboard_arrow_up),
                            ),
                            IconButton(
                              tooltip: 'ถัดไป',
                              onPressed: _hits.isEmpty ? null : _nextHit,
                              icon: const Icon(Icons.keyboard_arrow_down),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              //>>> ALERT dropdown <<<//
              if (alerts.isNotEmpty) ...[
                InkWell(
                  onTap: () => setState(() => _alertOpen = !_alertOpen),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      border: Border(
                        bottom: BorderSide(color: Colors.orange.shade200),
                        top: BorderSide(color: Colors.orange.shade200),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.campaign,
                            color: Colors.orange, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            alerts.isNotEmpty
                                ? 'สำคัญ: ${alerts.first.text}'
                                : 'โน๊ตพิเศษ ${alerts.length} รายการ',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        AnimatedRotation(
                          turns: _alertOpen ? 0.5 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(Icons.keyboard_arrow_down,
                              color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  child: _alertOpen
                      ? Container(
                          constraints: const BoxConstraints(maxHeight: 220),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.orange.shade200)),
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            itemCount: alerts.length,
                            separatorBuilder: (_, __) => Divider(
                              height: 10,
                              color: Colors.orange.shade100,
                            ),
                            itemBuilder: (context, index) {
                              final a = alerts[index];
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.campaign,
                                      color: Colors.orange, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        text(
                                          context,
                                          a.text,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            text(
                                              context,
                                              a.date ?? '',
                                              fontSize: 11,
                                              color: Colors.grey.shade600,
                                            ),
                                            const SizedBox(width: 6),
                                            Flexible(
                                              child: text(
                                                context,
                                                a.createByName ?? '',
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],

              // Body
              Expanded(
                child: Container(
                    color: const Color(0xFFF6F7F9),
                    child: _loading
                        ? const Center(child: CircularProgressIndicator())
                        : _error != null
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(_error!,
                                        style: const TextStyle(
                                            color: Colors.redAccent)),
                                    const SizedBox(height: 8),
                                    OutlinedButton.icon(
                                      onPressed: _loadChat,
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('ลองใหม่'),
                                    ),
                                  ],
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: _loadChat,
                                child: ListView.builder(
                                  controller: _scroll,
                                  padding: const EdgeInsets.all(12),
                                  itemCount: _messages.length,
                                  itemBuilder: (_, i) {
                                    _msgKeys.putIfAbsent(i, () => GlobalKey());
                                    final isCurrentHit = _hits.isNotEmpty &&
                                        _hits[_hitIndex] == i;

                                    final msg = _messages[i];

                                    if ((msg.type ?? '').toUpperCase() ==
                                        'AUTO') {
                                      return Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          key: _msgKeys[i],
                                          margin:
                                              const EdgeInsets.only(bottom: 6),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // บับเบิลข้อความ AUTO
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.green.shade50,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(
                                                          maxWidth: 280),
                                                  child: text(
                                                    context,
                                                    msg.text,
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                             
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 6,
                                                    right: 6,
                                                    bottom: 2,
                                                    top: 2),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    text(
                                                      context,
                                                      'ข้อความจากระบบ',
                                                      color: Colors.green,
                                                      fontSize: 12,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    text(
                                                      context,
                                                      msg.date ?? '',
                                                      color:
                                                          Colors.grey.shade500,
                                                      fontSize: 12,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                    return Container(
                                      key: _msgKeys[i],
                                      margin: const EdgeInsets.only(bottom: 6),
                                      child: ChatDetail(
                                        message: _messages[i],
                                        onSetAlert: UpdateAlert,
                                        highlight: _query,
                                        isHighlighted: isCurrentHit,
                                      ),
                                    );
                                  },
                                ),
                              )),
              ),

              SafeArea(
                top: false,
                child: Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          minLines: 1,
                          maxLines: 4,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _send(),
                          decoration: InputDecoration(
                            hintText: 'พิมพ์ข้อความ...',
                            filled: true,
                            fillColor: const Color(0xFFF1F3F5),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: _sending ? null : _send,
                        icon: _sending
                            ? const CircularProgressIndicator(strokeWidth: 2)
                            : const Icon(Icons.send),
                        label: const Text('ส่ง'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
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
    );
  }
}
