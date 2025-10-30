import 'package:admin_dokter_panggil/src/models/pasien_show_model.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:flutter/material.dart';

class MrDetailRiwayat extends StatefulWidget {
  const MrDetailRiwayat({
    super.key,
    this.pasien,
  });

  final Pasien? pasien;

  @override
  State<MrDetailRiwayat> createState() => _MrDetailRiwayatState();
}

class _MrDetailRiwayatState extends State<MrDetailRiwayat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat pasien',
        ),
        foregroundColor: Colors.black,
        backgroundColor: kBgRedLightColor,
        systemOverlayStyle: kSystemOverlayLight,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 28),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    widget.pasien!.jk == 1
                        ? 'images/avatar_1_1.png'
                        : 'images/avatar_2_1.png',
                    height: 55,
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                    child: ListTile(
                  title: Text(
                    '${widget.pasien!.namaPasien}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        '${widget.pasien!.umur}',
                        style:
                            const TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                      const SizedBox(
                        width: 28.0,
                      ),
                      Text(
                        '${widget.pasien!.jenisKelamin}',
                        style:
                            const TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
      body: Container(),
    );
  }
}
