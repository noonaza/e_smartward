// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:e_smartward/widget/text.dart';
import 'package:flutter/material.dart';

import 'package:e_smartward/Model/list_pet_model.dart';
import 'package:e_smartward/Model/list_user_model.dart';
import 'package:e_smartward/util/tlconstant.dart';
import 'package:e_smartward/widget/show_dialog.dart';

// ignore: must_be_immutable
class CardPet extends StatefulWidget {
  final List<ListUserModel> lUserLogin;
  final String hnNumber;
  final Map<String, String> headers;
  Function cb;

  CardPet({
    super.key,
    required this.lUserLogin,
    required this.hnNumber,
    required this.headers,
    required this.cb,
  });

  @override
  State<CardPet> createState() => _CardPetState();

  loadApiPetAdmit(String s) {}
}

class _CardPetState extends State<CardPet> {
  List<ListPetModel> lPetAdmit = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () async {
      await loadApiPetAdmit(widget.hnNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: lPetAdmit.length,
          itemBuilder: (context, index) {
            String hn = lPetAdmit[index].hn ?? '';
            String name = lPetAdmit[index].pet_name ?? '';
            String site = lPetAdmit[index].base_site_branch_id ?? '';
            String ward = lPetAdmit[index].ward ?? '';
            String bed = lPetAdmit[index].bed_number ?? '';
            String doctor = lPetAdmit[index].doctor ?? '';

            String formattedText =
                'HN: $hn\nName: $name\nSite: $site\nWard: $ward\nเตียง: $bed\nชื่อแพทย์: $doctor';

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

  loadApiPetAdmit(String hnNumber) async {
    String api = '${TlConstant.syncApi}/get_data_admit';
    final dio = Dio();

    try {
      final response = await dio.post(
        api,
        data: {
          'hn_number': hnNumber,
        },
        options: Options(
          headers: widget.headers,
        ),
      );

      if (response.data['code'] == 1) {
        if (response.data['body'] is List) {
          setState(() {
            lPetAdmit = (response.data['body'] as List).map((item) {
              return ListPetModel(
                  an: item['an'],
                  base_site_branch_id: item['base_site_branch_id'],
                  bed_number: item['bed_number'],
                  hn: hnNumber,
                  owner_name: item['owner_name'],
                  pet_name: item['pet_name'],
                  pet_type: item['pet_type'],
                  room_type: item['room_type'],
                  visit_id: item['visit_id'],
                  ward: item['ward'],
                  doctor: item['doctor']);
            }).toList();
            widget.cb(lPetAdmit);
            // print('listPet: $lPetAdmit');
          });
        }
      } else if (response.data['code'] == 401) {
        dialog.token(context, response.data['message']);
      } else {
        dialog.Error(context, response.data['message']);
      }
    } catch (e) {
      dialog.Error(context, 'Failed to load data. Please try again.');
    }
  }
}
