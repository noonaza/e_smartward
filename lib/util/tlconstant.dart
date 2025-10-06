import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../Model/doctor_model.dart';
import '../screen/login_screen.dart';

class TlConstant {
  //workstepupdate
  // static const String syncApi = 'http://192.168.98.10:8081';
  static const String syncApi = 'https://uat-api.thonglorpet.com/smart-ward';
//  static const String syncApi = 'https://e-api.thonglorpet.com/smart-ward';

//  static final String version = '1.2.3'; // userAdmin
  static final String version = 'UAT V.2.0.0'; // userAdmin

  static int runID() => DateTime.now().millisecondsSinceEpoch;
  static String random() => Random().nextInt(999).toString().padLeft(3, '0');

  static String Authorization() =>
      'Basic ${base64Encode(utf8.encode('dev2024:tlpdev@2024'))}';

  static Map<String, String> headers({required String token}) =>
      {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};

  static Future<Widget> ResponseError(
      BuildContext context, Response<dynamic> response) async {
    if (response.data['code'] == 401) {
      return await showDialog(
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
                Text(response.data['message']),
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
              )
            ],
          );
        },
      );
    } else {
      return await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: SizedBox(
                height: 120,
                child: Center(child: Text(response.data['message']))),
          );
        },
      );
    }
  }
}

class Func {
  static List<String> generateMedicationTimes({
    required String startTime,
    required int intervalHours,
  }) {
    final parts = startTime.split(":");
    final startHour = int.parse(parts[0]);
    final startMinute = int.parse(parts[1]);

    DateTime time = DateTime(0, 1, 1, startHour, startMinute);

    List<String> times = [];
    for (int i = 0; i < 24; i += intervalHours) {
      times.add(
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}');
      time = time.add(Duration(hours: intervalHours));
      if (time.hour == startHour && time.minute == startMinute) {
        break;
      }
    }

    return times;
  }

  static String fullName({
    required List<DoctorModel> ListDoctors,
    required String? empId,
  }) {
    return ListDoctors.where((e) => e.employee_id == empId)
            .firstOrNull
            ?.full_nameth ??
        empId ??
        '-';
  }
}
