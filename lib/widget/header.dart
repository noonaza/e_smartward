import 'package:e_smartward/screen/login_screen.dart';
import 'package:e_smartward/screen/menu_screen.dart';
import 'package:e_smartward/widget/text.dart';
import 'package:flutter/material.dart';

class Header {
  Header(BuildContext context);

  static title(
      {required String title,
      required BuildContext context,
      required Function onHover,
      required Function onTap,
      required bool isBack}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PreferredSize(
          preferredSize: const Size.fromHeight(60), // Height of the AppBar
          child: Container(
            alignment: Alignment.center,
            height: 30,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Image.asset(
                      //   'assets/icons/logo.png',
                      //   width: 30,
                      //   height: 30,
                      // ),
                      const SizedBox(width: 5),
                      text(
                        context,
                        'e-Smart Ward',
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[700],
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            TextButton(
                              child: text(context, 'Menu',
                                  color: Colors.teal[800]),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MenuScreen(
                                      headers: {},
                                    ),
                                  ),
                                );
                              },
                            ),
                            text(context, ' | ', color: Colors.teal[800]),
                            TextButton(
                              child: text(context, 'Log Out',
                                  color: Colors.teal[800]),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                            ),
                            Icon(
                              Icons.power_settings_new_outlined,
                              size: 15,
                              color: Colors.teal[800],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
