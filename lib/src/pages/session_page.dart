import 'package:dokter_panggil/src/blocs/auth_bloc.dart';
import 'package:dokter_panggil/src/pages/login_page.dart';
import 'package:dokter_panggil/src/pages/root_page.dart';
import 'package:dokter_panggil/src/source/local_notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Sessionpage extends StatefulWidget {
  const Sessionpage({Key? key}) : super(key: key);

  @override
  State<Sessionpage> createState() => _SessionpageState();
}

class _SessionpageState extends State<Sessionpage> {
  DateTime? currentBackPressTime;

  @override
  initState() {
    super.initState();
    authbloc.restoreSession();
    _getMessage();
  }

  void _getMessage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotificationService.showNotification(message);
    });
  }

  Future<bool> willPop(bool didPop) {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 1)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: "Tap sekali lagi untuk keluar",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: authbloc.isSessionValid,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!) {
          return PopScope(
            onPopInvoked: willPop,
            child: const Rootpage(),
          );
        }
        return const Loginpage();
      },
    );
  }
}
