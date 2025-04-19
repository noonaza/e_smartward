import 'package:e_smartward/Model/list_user_model.dart';
import 'package:e_smartward/screen/admit_screen.dart';
import 'package:e_smartward/screen/round_ward_screen.dart';
import 'package:e_smartward/widget/header.dart';
import 'package:e_smartward/widgets/text.copy';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<ListUserModel> lUserLogin = [];
  late Map<String, String> headers_;

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
              ),
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
                                    builder: (context) => AdmitScreen(
                                          lUserLogin: lUserLogin,
                                          headers: headers_,
                                          lDataCard: [],
                                          onDelete: (int index) {},
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
                      const SizedBox(
                        width: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {},
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
                                'assets/images/chart.png',
                                width: 50,
                                height: 50,
                              ),
                              const SizedBox(height: 15),
                              text(
                                context,
                                "Chart",
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
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RoundWardScreen()));
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
                                'assets/images/ward.png',
                                width: 50,
                                height: 50,
                              ),
                              const SizedBox(height: 15),
                              text(
                                context,
                                "Round Ward",
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
                          onPressed: () {},
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
                                'assets/images/food.png',
                                width: 50,
                                height: 50,
                              ),
                              const SizedBox(height: 15),
                              text(
                                context,
                                "Observing Symptoms And Food Preparation",
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
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {},
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
                      const SizedBox(
                        width: 240,
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
