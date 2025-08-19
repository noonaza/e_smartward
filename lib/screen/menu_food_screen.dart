// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:e_smartward/screen/note_screen.dart';
import 'package:flutter/material.dart';

import 'package:e_smartward/Model/list_user_model.dart';
import 'package:e_smartward/screen/manage_food_screen.dart';
import 'package:e_smartward/widget/header.dart';
import 'package:e_smartward/widget/text.dart';

// ignore: must_be_immutable
class MenuFoodScreen extends StatefulWidget {
  Map<String, String> headers;
  List<ListUserModel> lUserLogin;

  MenuFoodScreen({
    Key? key,
    required this.headers,
    required this.lUserLogin,
  }) : super(key: key);

  @override
  _MenuFoodScreenState createState() => _MenuFoodScreenState();
}

class _MenuFoodScreenState extends State<MenuFoodScreen> {
  List<ListUserModel> lUserLogin = [];

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 225, 242, 243),
                Color.fromARGB(255, 201, 234, 240),
                Color.fromARGB(255, 221, 248, 255),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Header.title(
                  title: '',
                  context: context,
                  onHover: (value) {},
                  onTap: () {},
                  isBack: true,
                  headers: widget.headers,
                  lUserLogin: widget.lUserLogin),
              Expanded(
                child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NoteScreen(
                                          headers: widget.headers,
                                          lUserLogin: widget.lUserLogin,
                                          groupId: '',
                                          isWardMode: true,
                                        )));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            fixedSize: const Size(160, 160),
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/note.png',
                                width: 70,
                                height: 70,
                              ),
                              const SizedBox(height: 15),
                              text(
                                context,
                                "Nurse Note",
                                color: Colors.blue[900],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ManageFoodScreen(
                                          headers: widget.headers,
                                          lUserLogin: widget.lUserLogin,
                                        )));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            fixedSize: const Size(160, 160),
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/cook.png',
                                width: 70,
                                height: 70,
                              ),
                              const SizedBox(height: 15),
                              text(
                                context,
                                "Meal Prep",
                                color: Colors.blue[900],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ])),
              ),
            ],
          )),
    );
  }
}
