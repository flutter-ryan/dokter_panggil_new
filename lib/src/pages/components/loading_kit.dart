import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingKit extends StatelessWidget {
  const LoadingKit({
    Key? key,
    this.color = Colors.white,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SpinKitPouringHourGlass(
      size: 52.0,
      color: color,
    );
  }
}
