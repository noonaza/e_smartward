// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:e_smartward/api/manage_food_api.dart';
import 'package:flutter/material.dart';
import 'package:e_smartward/Model/list_pet_model.dart';
import 'package:e_smartward/Model/list_user_model.dart';
import 'package:e_smartward/widgets/text.copy';

// ignore: must_be_immutable
class ManageAdmit extends StatefulWidget {
  final List<ListUserModel> lUserLogin;
  final String hnNumber;
  final Map<String, String> headers;
  Function cb;
  

  ManageAdmit({
    super.key,
    required this.lUserLogin,
    required this.hnNumber,
    required this.headers,
    required this.cb,
  
  });

  @override
  State<ManageAdmit> createState() => _ManageAdmitState();

  loadApiPetAdmit(String s) {}
}

class _ManageAdmitState extends State<ManageAdmit> {
  List<ListPetModel> lPetAdmit = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () async {
      await ManageFoodApi().loadListAdmit(context,headers_: widget.headers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: lPetAdmit.length,
          itemBuilder: (context, index) {
            String hn = lPetAdmit[index].hn ?? '';
            String name = lPetAdmit[index].pet_name ?? '';
            String site = lPetAdmit[index].base_site_branch_id ?? '';
            String ward = lPetAdmit[index].ward ?? '';
            String bed = lPetAdmit[index].bed_number ?? '';

            String formattedText =
                'HN: $hn\nName: $name\nSite: $site\nWard: $ward\nเตียง: $bed';

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
}
