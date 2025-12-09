import 'package:e_smartward/screen/admit_screen_V2.dart';
import 'package:e_smartward/screen/admit_screen_v1.dart';
import 'package:flutter/material.dart';
import 'package:e_smartward/Model/list_user_model.dart';
// import 'package:e_smartward/screen/admit_screen.dart';
import 'package:e_smartward/screen/menu_food_screen.dart';
import 'package:e_smartward/screen/round_ward_screen.dart';
import 'package:e_smartward/widget/header.dart';
import 'package:e_smartward/widget/text.dart';

// ignore: must_be_immutable
class MenuScreen extends StatefulWidget {
  Map<String, String> headers;
  List<ListUserModel> lUserLogin;
  MenuScreen({
    super.key,
    required this.headers,
    required this.lUserLogin,
  });

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
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
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdmitScreenV2(
                                          lUserLogin: widget.lUserLogin,
                                          headers: widget.headers,
                                          lDataCard: [],
                                          onDelete: (int index) {},
                                        )));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            fixedSize: const Size(180, 180),
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/admin.png',
                                width: 50,
                                height: 50,
                              ),
                              const SizedBox(height: 15),
                              text(
                                context,
                                "Admit",
                                color: Colors.blue[900],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // const SizedBox(
                      //   width: 60,
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(10.0),
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) => DashboardScreen(
                      //                     lDataCard: [],
                      //                     petNames: [],
                      //                   )));
                      //     },
                      //     style: ElevatedButton.styleFrom(
                      //       backgroundColor: Colors.white,
                      //       fixedSize: const Size(180, 180),
                      //       elevation: 15,
                      //       shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(10.0)),
                      //     ),
                      //     child: Column(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Image.asset(
                      //           'assets/images/chart.png',
                      //           width: 50,
                      //           height: 50,
                      //         ),
                      //         const SizedBox(height: 15),
                      //         text(
                      //           context,
                      //           "Patient on Board",
                      //           color: Colors.blue[900],
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RoundWardScreen(
                                          lDataCard: [],
                                          headers: widget.headers,
                                          lUserLogin: widget.lUserLogin,
                                          lPetAdmit: [],
                                          lListAn: [],
                                        )));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            fixedSize: const Size(180, 180),
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/ward.png',
                                width: 50,
                                height: 50,
                              ),
                              const SizedBox(height: 15),
                              text(
                                context,
                                "Progress Note",
                                color: Colors.blue[900],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // const SizedBox(
                      //   width: 60,
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MenuFoodScreen(
                                        headers: widget.headers,
                                        lUserLogin: widget.lUserLogin)));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            fixedSize: const Size(180, 180),
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/food.png',
                                width: 50,
                                height: 50,
                              ),
                              const SizedBox(height: 15),
                              text(
                                context,
                                "Daily Care Record",
                                color: Colors.blue[900],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            fixedSize: const Size(180, 180),
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/setting.png',
                                width: 50,
                                height: 50,
                              ),
                              const SizedBox(height: 15),
                              text(
                                context,
                                "Setting",
                                color: Colors.blue[900],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 260,
                      ),
                    ],
                  )
                ])),
              ),
            ],
          )),
    );
  }
}
