import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingKit extends StatelessWidget {
  const LoadingKit({
    super.key,
    this.color = Colors.white,
    this.size = 52.0,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SpinKitPouringHourGlass(
      size: size,
      color: color,
    );
  }
}
