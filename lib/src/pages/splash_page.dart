import 'dart:io';

import 'package:dokter_panggil/src/pages/session_page.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Splashpage extends StatefulWidget {
  const Splashpage({super.key});

  @override
  State<Splashpage> createState() => _SplashpageState();
}

class _SplashpageState extends State<Splashpage> {
  String version = '1.0.0';

  @override
  initState() {
    super.initState();
    _checkUpdate();
  }

  void _checkUpdate() {
    if (Platform.isAndroid) {
      InAppUpdate.checkForUpdate().then((info) {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          InAppUpdate.startFlexibleUpdate().then((_) {
            _navigateNextPage();
          }).catchError((e) {
            Fluttertoast.showToast(
              msg: e.toString(),
            );
            _navigateNextPage();
          });
          return;
        }
        _navigateNextPage();
      }).catchError((e) {
        Fluttertoast.showToast(msg: e.toString());
        _navigateNextPage();
      });
      return;
    }
    _navigateNextPage();
  }

  Future<void> _navigateNextPage() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      version = info.version;
    });
    Future.delayed(
      const Duration(seconds: 3),
      () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const Sessionpage(),
        ),
        (route) => false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: 'imageLogo',
                    child: Container(
                      height: 150,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/logo_only.png'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  const Text(
                    'Dokter Panggil\nAdministration',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                      height: 1,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '\u00a92022 Dokter Panggil',
                      style: TextStyle(fontSize: 11.0, color: Colors.grey),
                    ),
                    Text(
                      'V.$version',
                      style:
                          const TextStyle(fontSize: 11.0, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
