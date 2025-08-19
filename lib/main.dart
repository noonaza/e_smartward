import 'dart:ui';
import 'package:e_smartward/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iCare Smart Ward',
      scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData(
          useMaterial3: false,
          primaryColor: Colors.blueAccent[100],
          textTheme: GoogleFonts.mitrTextTheme()),
      debugShowCheckedModeBanner: false,
      home:
          // AdmitScreen(),
          // RoundWardScreen()
          // NewUserApprovalDialog()
          //     ListUserScreen(
          //   lUserLogin: [],
          //   newUser: '',
          // )

          // ),
          LoginScreen(),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
