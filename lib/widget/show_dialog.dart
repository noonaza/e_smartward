import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_smartward/screen/login_screen.dart';
import 'package:e_smartward/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class dialog {
  static load(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: SizedBox(
            width: 260,
            height: 100,
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.asset('images/loading.gif'),
                  ),
                  text(context, 'ระบบกำลังดึงข้อมูล')
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static save(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: SizedBox(
            width: 260,
            height: 100,
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.asset('images/boxes.gif'),
                  ),
                  text(context, 'ระบบกำลังบันทึกข้อมูล')
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static loadData(BuildContext context) {
    return AwesomeDialog(
      context: context,
      customHeader: Image.asset('assets/gif/loaddata.gif'),
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      width: MediaQuery.of(context).size.width * 0.5,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          SizedBox(height: 10),
          Text(
            "กำลังดึงข้อมูล กรุณารอสักครู่...",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 10),
        ],
      ),
    ).show();
  }

  static cancel(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: SizedBox(
            width: 260,
            height: 100,
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.asset('images/no-data.gif'), //
                  ),
                  text(context, 'ระบบกำลังบันทึกการยกเลิก')
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static comment(BuildContext context, String label,
      {String? image, double? width, double? height, bool? isClosePopup}) {
    return showDialog(
      barrierDismissible: isClosePopup ?? false,
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: SizedBox(
            width: width ?? 260,
            height: height ?? 100,
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: image == null
                        ? Image.asset('images/no-data.gif')
                        : Image.asset('images/${image}'), //?? "alertList.gif"
                  ),
                  text(context, label)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static token(BuildContext context, String message) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Column(
            children: [
              CircleAvatar(
                child: Icon(Icons.check_circle_outline_outlined),
                radius: 30,
                backgroundColor: Color.fromARGB(255, 55, 107, 79),
              ),
              SizedBox(height: 30),
              Text(message),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Login Again'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  static Nodata(BuildContext context, String message) {
    return showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircleAvatar(
                radius: 32,
                backgroundColor: Color.fromARGB(255, 214, 130, 34),
                child: Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
          content: text(
            context,
            message,
            fontSize: 16,
            textAlign: TextAlign.center,
            color: Color(0xFF555555),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 214, 130, 34),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                Navigator.of(ctx, rootNavigator: true).pop();
              },
              child: text(context, 'ตกลง', fontSize: 16, color: Colors.white),
            ),
          ],
        );
      },
    );
  }

  static Error(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: SizedBox(
            height: 120,
            child: Center(
              child: Text(message),
            ),
          ),
        );
      },
    );
  }

  Widget DialogButton({
    required BuildContext context,
    required String label,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      onPressed: onPressed,
      child: text(context, label),
    );
  }

  static void success(BuildContext context, String s) {}
}
