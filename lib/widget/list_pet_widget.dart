// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:e_smartward/Model/list_pet_model.dart';
import 'package:e_smartward/Model/list_user_model.dart';
import 'package:e_smartward/util/tlconstant.dart';
import 'package:e_smartward/widget/show_dialog.dart';
import 'package:e_smartward/widget/text.dart';

// ignore: must_be_immutable
class ListPetWidget extends StatefulWidget {
  final List<ListUserModel> lUserLogin;
  final Map<String, String> headers;
  Function cb;

  ListPetWidget({
    super.key,
    required this.lUserLogin,
    required this.headers,
    required this.cb,
  });

  @override
  State<ListPetWidget> createState() => _CardPetState();

  loadApiPetAdmit(String s) {}
}

class _CardPetState extends State<ListPetWidget> {
  List<ListPetModel> lPetAdmit = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () async {
      await loadListAdmit(context,
          ward: '',
          siteCode: '',
          groupId: '',
          type: '',
          headers_: widget.headers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: lPetAdmit.length,
          itemBuilder: (context, index) {
            String hn = lPetAdmit[index].hn ?? '';
            String name = lPetAdmit[index].pet_name ?? '';
            String site = lPetAdmit[index].base_site_branch_id ?? '';
            String ward = lPetAdmit[index].ward ?? '';
            String bed = lPetAdmit[index].bed_number ?? '';
            String date = lPetAdmit[index].admit_datetimes ?? '';

            String formattedText =
                'HN: $hn\nName: $name\nSite: $site\nWard: $ward\nเตียง: $bed\วันที่เข้ารักษา: $date';

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.teal, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 50.0),
                        child: text(context, formattedText,
                            textAlign: TextAlign.start, color: Colors.teal),
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 8,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage('assets/images/ward.png'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  loadListAdmit(
    BuildContext context, {
    required String ward,
    required String siteCode,
    required String groupId,
    required String type,
    required Map<String, String> headers_,
  }) async {
    List<ListPetModel> admit = [];
    String api = '${TlConstant.syncApi}/get_list_admid';
    final dio = Dio();

    try {
      final response = await dio.post(
        api,
        data: {
          'type': type,
          'group_id': groupId,
          'site_code': siteCode,
          'ward': ward,
        },
        options: Options(headers: headers_),
      );

      if (response.data['code'] == 1) {
        final body = response.data['body'];
        if (body is List) {
          admit = body.map<ListPetModel>((item) {
            return ListPetModel(
              visit_id: item['visit_id'],
              hn: item['hn'],
              an: item['an'],
              owner_name: item['owner_name'],
              pet_name: item['pet_name'],
              pet_type: item['pet_type'],
              base_site_branch_id: item['base_site_branch_id'],
              ward: item['ward'],
              room_type: item['room_type'],
              bed_number: item['bed_number'],
                       admit_date: item['admit_date'],
              admit_time: item['admit_time'],
              admit_datetimes: item['admit_datetimes'],
            );
          }).toList();
        }
      } else if (response.data['code'] == 401) {
        dialog.token(context, response.data['message']);
      } else {
        dialog.Error(context, response.data['message']);
      }
    } catch (e) {
      dialog.Error(context, 'Failed to load group codes.');
    }

    return admit;
  }
}
