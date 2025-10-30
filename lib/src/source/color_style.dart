import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const kPrimaryColor = Color(0xFFD92F30);
const kSecondaryColor = Color(0xFFFF5B5B);
const kBgRedLightColor = Color(0xFFFFEFEF);
const kGreenColor = Color(0xFF208310);
const kWarningColor = Color(0xFFFFC700);
const kTextGreyColor = Color(0xFF8D8D8D);
const kTextGreyLightColor = Color(0xFFCCCCCC);
const kDividerColor = Color(0xFFD9D9D9);
const kStrokeRedColor = Color(0xFFFF5B5B);

const kSystemOverlayLight = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.dark,
  systemNavigationBarColor: Colors.white,
  systemNavigationBarIconBrightness: Brightness.dark,
);
const kSystemOverlayDark = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.light,
  systemNavigationBarColor: Colors.white,
  systemNavigationBarIconBrightness: Brightness.dark,
);
