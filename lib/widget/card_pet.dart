// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:e_smartward/dialog/chat_dialog.dart';
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
  final ValueNotifier<bool> noteBtnVisible;
  Function cb;

  CardPet({
    super.key,
    required this.lUserLogin,
    required this.hnNumber,
    required this.headers,
    required this.noteBtnVisible,
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
        height: 230,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: lPetAdmit.length,
          itemBuilder: (context, index) {
            final pet = lPetAdmit[index];
            final hn = pet.hn ?? '';
            final name = pet.pet_name ?? '';
            final site = pet.base_site_branch_id ?? '';
            final ward = pet.ward ?? '';
            final bed = pet.bed_number ?? '';
            final doctor = pet.doctor ?? '';
            final date = pet.admit_date ?? '';

            final formattedText =
                'HN: $hn\nName: $name\nSite: $site\nWard: $ward\nเตียง: $bed\nชื่อแพทย์: $doctor\nวันที่เข้ารักษา: $date';

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
                        padding: const EdgeInsets.only(left: 100.0),
                        child: Text(
                          formattedText,
                          textAlign: TextAlign.start,
                          style: const TextStyle(color: Colors.teal),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 5,
                    top: 30,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: widget.noteBtnVisible,
                      builder: (context, canShow, _) {
                        if (!canShow) {
                          return SizedBox.shrink();
                        }
                        return IconButton(
                          icon: const Icon(Icons.note_alt,
                              color: Colors.teal, size: 28),
                          onPressed: () {
                            final admitId = pet.visit_id?.toString() ?? '';
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (_) => ChatDialog(
                                headers: widget.headers,
                                visitId: admitId,
                                lUserLogin: widget.lUserLogin,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Positioned(
                    left: 8,
                    child: FutureBuilder<ImageInfo>(
                      future: _getImageInfo(pet.image),
                      builder: (context, snapshot) {
                        ImageProvider imageProvider;

                        if (snapshot.hasData) {
                          final size = snapshot.data!.image;
                          if (size.width == 80 && size.height == 80) {
                        
                            imageProvider =
                                const AssetImage('assets/images/petnull.png');
                          } else {
                            imageProvider = NetworkImage(pet.image!.trim());
                          }
                        } else {
                    
                          imageProvider =
                              const AssetImage('assets/images/petnull.png');
                        }

                        return Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.teal, width: 2),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: imageProvider,
                            ),
                          ),
                        );
                      },
                    ),
                  )
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
                  id: item['id'],
                  an: item['an'],
                  base_site_branch_id: item['base_site_branch_id'],
                  bed_number: item['bed_number'],
                  hn: item['hn'],
                  owner_name: item['owner_name'],
                  pet_name: item['pet_name'],
                  pet_type: item['pet_type'],
                  room_type: item['room_type'],
                  visit_id: item['visit_id'],
                  ward: item['ward'],
                  doctor: item['doctor'],
                  image: item['image']);
            }).toList();
            widget.cb(lPetAdmit);
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

  Future<ImageInfo> _getImageInfo(String? url) async {
    if (url == null || url.trim().isEmpty || url.toLowerCase() == 'null') {
      throw Exception("No image");
    }

    final completer = Completer<ImageInfo>();
    final imageProvider = NetworkImage(url.trim());

    imageProvider.resolve(const ImageConfiguration()).addListener(
          ImageStreamListener((ImageInfo info, bool _) {
            completer.complete(info);
          }, onError: (dynamic _, __) {
            completer.completeError("Load error");
          }),
        );

    return completer.future;
  }
}
