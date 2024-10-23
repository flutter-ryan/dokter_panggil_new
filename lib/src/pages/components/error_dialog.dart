import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    Key? key,
    this.message,
    this.onTap,
  }) : super(key: key);

  final String? message;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: SizedBox(
        width: SizeConfig.blockSizeHorizontal * 55,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 22.0, horizontal: 18.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.red,
                        size: 52.0,
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Peringatan!',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        '$message',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 8.0,
                      )
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  child: Material(
                    color: Colors.red,
                    child: InkWell(
                      onTap: onTap ?? () => Navigator.pop(context),
                      child: const SizedBox(
                        width: double.infinity,
                        height: 42.0,
                        child: Center(
                          child: Text(
                            'Tutup',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                ),
                color: Colors.grey,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
