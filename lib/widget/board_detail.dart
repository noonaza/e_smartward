import 'package:e_smartward/widget/board_data.dart';
import 'package:flutter/material.dart';

import 'package:e_smartward/widget/colors_board.dart';

class BoardDetail extends StatelessWidget {
  const BoardDetail({super.key, required this.data});
  final DataCard data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: BedColors.bgPtOf(data.tone),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            spreadRadius: 0,
            color: Colors.black12,
            offset: Offset(2, 5),
          ),
        ],
        border: Border.all(color: BedColors.borderOf(data.tone), width: 3),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 38),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black12),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      data.petType == "CA"
                          ? 'assets/images/dog1.png'
                          : data.petType == "FE"
                              ? 'assets/images/cat.png'
                              : 'assets/images/default.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...data.petNames.map(
                        (n) => Text(
                          '$n${data.petType != null && data.petType!.isNotEmpty ? ' (${data.petType})' : ''}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 23,
                            color: Colors.grey.shade800,
                            height: 1.05,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'คุณ : ${data.ownerName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        'HN : ${data.hn}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 6,
            right: 6,
            child: UnconstrainedBox(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: data.cornerIcons.map((w) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: SizedBox(width: 35, height: 35, child: w),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
