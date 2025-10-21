import 'package:admin_dokter_panggil/src/pages/components/close_button_widget.dart';
import 'package:flutter/material.dart';

class ListJenisKelamin extends StatelessWidget {
  const ListJenisKelamin({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 22.0, left: 18.0, right: 18.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Pilih jenis kelamin',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                CloseButtonWidget(),
              ],
            ),
          ),
          const SizedBox(
            height: 18.0,
          ),
          ListTile(
            onTap: () =>
                Navigator.pop(context, {'id': "1", 'jenis': 'Laki-laki'}),
            leading: const Icon(Icons.male),
            title: const Text('Laki-laki'),
          ),
          const Divider(height: 0.0),
          ListTile(
            onTap: () =>
                Navigator.pop(context, {'id': "2", 'jenis': 'Perempuan'}),
            leading: const Icon(Icons.female),
            title: const Text('Perempuan'),
          ),
          const SizedBox(
            height: 22.0,
          ),
        ],
      ),
    );
  }
}
