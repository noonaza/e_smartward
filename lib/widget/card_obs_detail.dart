import 'dart:convert';
import 'package:e_smartward/Model/list_data_obs_model.dart';
import 'package:e_smartward/widgets/text.copy';
import 'package:flutter/material.dart';

class ObsListWidget extends StatefulWidget {
  final List<ListDataObsDetailModel> lSettingTime;
  final List<ListDataObsDetailModel> lDataObs;
  final Map<String, String> headers;
  final Function(ListDataObsDetailModel obs) onEdit;
  final Function(int index) onDelete;
  final VoidCallback onAdd;
  final VoidCallback onCopy;

  const ObsListWidget({
    super.key,
    required this.onEdit,
    required this.onDelete,
    required this.onAdd,
    required this.onCopy,
    required this.lDataObs,
    required this.headers,
    required this.lSettingTime,
  });

  @override
  _ObsListWidgetState createState() => _ObsListWidgetState();
}

class _ObsListWidgetState extends State<ObsListWidget> {
  bool get isHideBtn {
    return widget.lDataObs
        .any((e) => e.id != null && e.id.toString().trim().isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 3.1,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFFFE9E2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: widget.lDataObs.isEmpty
                  ? Center(child: text(context, 'No data'))
                  : ListView.builder(
                      itemCount: widget.lDataObs.length,
                      itemBuilder: (context, index) {
                        final obs = widget.lDataObs[index];
                        final isDisabled = widget.lDataObs[index].id != null;

                        final cleanedJson = obs.set_value!.replaceAllMapped(
                            RegExp(r'(\w+):'), (match) => '"${match[1]}":');
                        final Map<String, dynamic> setValue =
                            jsonDecode(cleanedJson);

                        final List<String> displayItems = [];
                        if (setValue['obs']?.toString() != '0') {
                          displayItems.add('obs');
                        }
                        if (setValue['col']?.toString() != '0') {
                          displayItems.add('col');
                        }

                        return GestureDetector(
                          onTap: isDisabled ? null : () => widget.onEdit(obs),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 1),
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    color: const Color.fromARGB(
                                        255, 255, 208, 192),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          text(context,
                                              "อาการ : ${obs.set_name}",
                                              color: const Color.fromARGB(
                                                  255, 215, 116, 114)),
                                          const SizedBox(height: 4),
                                          text(context,
                                              "หมายเหตุ : ${obs.remark ?? '-'}",
                                              color: const Color.fromARGB(
                                                  255, 215, 116, 114)),
                                          Wrap(
                                            children: displayItems.map((item) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 202, 64, 61),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    border: Border.all(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              215,
                                                              116,
                                                              114),
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: text(context, item,
                                                      color: Colors.white),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                          const SizedBox(height: 4),
                                          SizedBox(
                                            width: double.infinity,
                                            child: Wrap(
                                              spacing: 8,
                                              runSpacing: 8,
                                              children: obs.take_time != null &&
                                                      obs.take_time!.isNotEmpty
                                                  ? obs.take_time!
                                                      .replaceAll('[', '')
                                                      .replaceAll(']', '')
                                                      .replaceAll("'", '')
                                                      .split(',')
                                                      .map((time) => Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 0),
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          12,
                                                                      vertical:
                                                                          6),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    215,
                                                                    116,
                                                                    114),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                              ),
                                                              child: text(
                                                                context,
                                                                time.trim(),
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ))
                                                      .toList()
                                                  : [SizedBox()],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                if (!isHideBtn)
                                Positioned(
                                  right: 8.0,
                                  top: 10.0,
                                  child: IconButton(
                                    icon: const Icon(Icons.cancel,
                                        size: 20,
                                        color:
                                            Color.fromARGB(255, 215, 116, 114)),
                                    onPressed: () => widget.onDelete(index),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            if (!isHideBtn)
              Positioned(
                right: 8.0,
                bottom: 8.0,
                child: IconButton(
                  icon: const Icon(Icons.add_circle_outlined,
                      size: 35, color: Color.fromARGB(255, 184, 119, 15)),
                  onPressed: widget.onAdd,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
