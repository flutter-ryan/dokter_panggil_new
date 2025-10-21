import 'package:admin_dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';

class ConfirmDialogWidget extends StatelessWidget {
  const ConfirmDialogWidget({
    super.key,
    this.message = 'Anda yakin ingin menghapus data ini',
    required this.onConfirm,
    this.labelConfirm = 'Ya, Hapus',
  });

  final String? message;
  final Function() onConfirm;
  final String? labelConfirm;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: SizedBox(
        width: SizeConfig.blockSizeHorizontal * 35,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 22.0, horizontal: 18.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.help_outline_rounded,
                    color: Colors.blue,
                    size: 52.0,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Konfirmasi',
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
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: double.infinity,
                        height: 45.0,
                        color: Colors.red,
                        child: const Center(
                          child: Text(
                            'Batal',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(12),
                    ),
                    child: InkWell(
                      onTap: onConfirm,
                      child: Container(
                        width: double.infinity,
                        height: 45.0,
                        color: Colors.blue,
                        child: Center(
                          child: Text(
                            '$labelConfirm',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
