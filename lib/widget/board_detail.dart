import 'package:e_smartward/widget/board_data.dart';
import 'package:flutter/material.dart';

import 'package:e_smartward/widget/colors_board.dart';

class BoardDetail extends StatelessWidget {
  const BoardDetail({super.key, required this.data});
  final DataCard data;

  @override
  Widget build(BuildContext context) {
    final bool isGreen = data.tone == ColorTone.green;

    // ---- size tuning for green card (เตี้ย) ----
    final double fontSize = isGreen ? 14 : 16; //>> ข้อความอื่นๆ <<//
    final double fontSizename = isGreen ? 14 : 18; //>> ชื่อสัตว์ <<//
    final double avatar = isGreen ? 46 : 70; //>> รูปภาพ <<//
    final double vTop = isGreen ? 8 : 10; //>> ระยะห่างด้านบน <<//
    final double Bottom = isGreen ? 26 : 38; //>> ระยะห่างด้านล่าง <<//
    final double nameLineHeight = isGreen ? 1.0 : 1.05;
    final double infoLineHeight = isGreen ? 1.05 : 1.2;

    final List<String> petNamesToShow =
        isGreen ? data.petNames.take(1).toList() : data.petNames;

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
            padding: EdgeInsets.fromLTRB(12, vTop, 12, Bottom),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // avatar
                Container(
                  width: avatar,
                  height: avatar,
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
                              : 'assets/images/duck1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...petNamesToShow.map(
                        (n) => Text(
                          '$n${(data.petType != null && data.petType!.isNotEmpty) ? ' (${data.petType})' : ''}',
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: fontSizename,
                            color: Colors.grey.shade800,
                            height: nameLineHeight,
                          ),
                        ),
                      ),
                      SizedBox(height: isGreen ? 2 : 4),
                      Text(
                        'คุณ : ${data.ownerName}',
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: fontSize,
                          color: Colors.grey.shade700,
                          height: infoLineHeight,
                        ),
                      ),
                      Text(
                        'HN : ${data.hn}',
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: fontSize,
                          color: Colors.grey.shade700,
                          height: infoLineHeight,
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
                  final double iconSize = isGreen ? 20.0 : 22.0;
                  final double gap = isGreen ? 4.0 : 6.0;
                  return Padding(
                    padding: EdgeInsets.only(left: gap),
                    child:
                        SizedBox(width: iconSize, height: iconSize, child: w),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
