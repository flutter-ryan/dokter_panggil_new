import 'package:admin_dokter_panggil/src/pages/components/tile_data_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CardFileWidget extends StatelessWidget {
  const CardFileWidget({
    super.key,
    this.title,
    this.subtitle,
    this.tanggal,
    this.petugas,
    this.onPressed,
  });

  final String? title;
  final String? subtitle;
  final String? tanggal;
  final String? petugas;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              '$title',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '$subtitle',
              style: const TextStyle(color: Colors.grey),
            ),
            leading: SvgPicture.asset(
              'images/pdf-ic.svg',
              height: 42,
            ),
            minLeadingWidth: 12.0,
            trailing: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[100],
              foregroundColor: Colors.blue,
              child: IconButton(
                onPressed: onPressed,
                icon: const Icon(
                  Icons.more_vert_rounded,
                  size: 18,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TileDataCard(
                    title: 'Tanggal',
                    body: Text('$tanggal'),
                  ),
                ),
                Expanded(
                  child: TileDataCard(
                    title: 'Petugas',
                    body: Text('$petugas'),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 18,
          ),
        ],
      ),
    );
  }
}
