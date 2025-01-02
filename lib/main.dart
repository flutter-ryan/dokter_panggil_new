import 'package:dokter_panggil/src/pages/splash_page.dart';
import 'package:dokter_panggil/src/source/local_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

@pragma('vm:entry-point')
Future<void> _messageBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  LocalNotificationService.showNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(
    const DokterPanggil(),
  );
}

class DokterPanggil extends StatelessWidget {
  const DokterPanggil({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DRP Administration',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
        primarySwatch: Colors.red,
        useMaterial3: false,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('id'),
      ],
      home: const Splashpage(),
    );
  }
}
