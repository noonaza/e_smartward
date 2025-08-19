import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_smartward/Model/list_user_model.dart';
import 'package:e_smartward/screen/dashboard_screen.dart';
import 'package:e_smartward/screen/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import '../util/tlconstant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'preview_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List<ListUserModel> lUserLogin = [];
  String token = '';
  late Map<String, String> headers_;
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  TextEditingController userLoginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true; // State variable for password visibility

  void togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  Future<void> _loadSavedCredentials() async {
    String? savedUser = await storage.read(key: 'username');
    String? savedPassword = await storage.read(key: 'password');

    if (savedUser != null && savedPassword != null) {
      userLoginController.text = savedUser;
      passwordController.text = savedPassword;
    }
  }

  // ฟังก์ชันสำหรับบันทึกรหัสผ่านและชื่อผู้ใช้
  Future<void> _saveCredentials() async {
    await storage.write(key: 'username', value: userLoginController.text);
    await storage.write(key: 'password', value: passwordController.text);
  }

  @override
  void initState() {
    super.initState();
    userLoginController.text = '';
    passwordController.text = '';
    _loadSavedCredentials();

    Future.delayed(
      const Duration(milliseconds: 500),
      () async {
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_login.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 225, 242, 243).withOpacity(0.97),
                const Color.fromARGB(255, 201, 234, 240).withOpacity(0.97),
                const Color.fromARGB(255, 221, 248, 255).withOpacity(0.97),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        // Positioned(
        //   top: 15,
        //   right: 20,
        //   child: InkWell(
        //     onTap: () {
        //       // Navigator.push(
        //       //   context,
        //       //   MaterialPageRoute(
        //       //       builder: (context) => PreviewDashboard(
        //       //             lDataCard: [],
        //       //             petNames: [],
        //       //           )),
        //       // );

        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => DashboardScreen(
        //                   lDataCard: [],
        //                   petNames: [],
        //                 )),
        //       );
        //     },
        //     child: Image.asset(
        //       'assets/icons/dbicon.png',
        //       width: 35,
        //       height: 35,
        //     ),
        //   ),
        // ),
        Positioned(
          left: (MediaQuery.of(context).size.width / 2) -
              ((MediaQuery.of(context).size.width / 2.5) / 2),
          top: 10.0,
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width / 2.5,
            height: MediaQuery.of(context).size.height / 2.5,
            child: Tooltip(
              message: 'Version ${TlConstant.version} ',
              child: Image.asset(
                'assets/images/02.png',
                width: MediaQuery.of(context).size.width / 2.5,
              ),
            ),
          ),
        ),
        Positioned(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(height: 200),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: TextFormField(
                    onFieldSubmitted: (value) async {
                      await loadLogin();
                    },
                    controller: userLoginController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'User',
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: TextFormField(
                      onFieldSubmitted: (value) async {
                        await loadLogin();
                      },
                      obscureText: obscureText,
                      controller: passwordController,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: togglePasswordVisibility,
                        ),
                      )),
                ),
                SizedBox(
                  height: 50,
                  child: FractionallySizedBox(
                    alignment: Alignment.center,
                    widthFactor: 0.4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Card(
                        elevation: 0,
                        color: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: InkWell(
                          onTap: loadLogin,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          hoverColor: const Color.fromARGB(171, 113, 139, 178),
                          child: const Center(
                            child: Text(
                              ' LOG IN ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 57, 169, 171),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 120,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DashboardScreen(
                                    lDataCard: [],
                                    petNames: [],
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/icons/dbicon.png',
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'Patient on Board',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 54, 68, 94),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Update 20250818 | Version ${TlConstant.version} ',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  AddUserSF(name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('username', userLoginController.text.trim());
      prefs.setString('password', passwordController.text.trim());

      //  print(
      //  'testnug >>>> ${prefs.setString('username', userLoginController.text.trim())}');
    });
  }

  loadLogin() async {
    lUserLogin = [];
    FormData formData = FormData.fromMap(
      {
        "user_login": userLoginController.text,
        "pass_user": generateMd5(passwordController.text)
      },
      // {"user_login": 'noona', "pass_user": '1234'},
    );
    String api = '${TlConstant.syncApi}/login';
    final dio = Dio();

    // dio.options.headers['Authorization'] = TlConstant.Authorization();

    try {
      final response = await dio.post(api, data: formData);
      // print(response.data);
      _saveCredentials();

      if (response.data['code'] == 1) {
        for (var login in response.data['body']) {
          ListUserModel newLogin = ListUserModel.fromMap(login);
          lUserLogin.add(newLogin);
          headers_ = TlConstant.headers(token: newLogin.access_token!);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MenuScreen(
                      lUserLogin: lUserLogin,
                      headers: headers_,
                    )),
          );
        }
      } else if (response.data['code'] == 401) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Column(
                children: [
                  const CircleAvatar(
                    child: Icon(Icons.check_circle_outline_outlined),
                    radius: 30,
                    backgroundColor: Color.fromARGB(255, 55, 107, 79),
                  ),
                  const SizedBox(height: 30),
                  Text(response.data['message']),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Login Again'),
                  onPressed: () {},
                )
              ],
            );
          },
        );
      } else {
        await showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 10,
              backgroundColor: Colors.white,
              child: SizedBox(
                height: 300,
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        "assets/animations/errorLogin.json",
                        repeat: true,
                        width: 200,
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            response.data['message'],
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Text(
                            'Please check your username and password.',
                            style: TextStyle(
                              color: Color.fromARGB(255, 12, 62, 95),
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
}
