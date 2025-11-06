import 'package:admin_dokter_panggil/src/models/pasien_show_model.dart';
import 'package:flutter/material.dart';

class IdentitasPasienWidget extends StatelessWidget {
  const IdentitasPasienWidget({
    super.key,
    required this.pasien,
  });

  final Pasien pasien;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 28),
      child: Row(
        children: [
          Image.asset(
            'images/avatar_1.png',
            height: 55,
          ),
          const SizedBox(
            width: 8.0,
          ),
          Expanded(
              child: ListTile(
            title: Text(
              '${pasien.namaPasien}',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            subtitle: Row(
              children: [
                Text(
                  '${pasien.umur}',
                  style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
                const SizedBox(
                  width: 28.0,
                ),
                Text(
                  '${pasien.jenisKelamin}',
                  style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
