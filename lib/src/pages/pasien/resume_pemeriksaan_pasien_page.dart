import 'package:admin_dokter_panggil/src/pages/pasien/cppt_pasien_widget.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/rekam_medis_widget.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';

class ResumePemeriksaanPasienPage extends StatefulWidget {
  const ResumePemeriksaanPasienPage({
    super.key,
    required this.idKunjungan,
    required this.idPetugas,
  });

  final int idKunjungan;
  final int idPetugas;

  @override
  State<ResumePemeriksaanPasienPage> createState() =>
      _ResumePemeriksaanPasienPageState();
}

class _ResumePemeriksaanPasienPageState
    extends State<ResumePemeriksaanPasienPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Expanded(
            child: TabBarView(
              children: [
                RekamMedisWidget(
                  idKunjungan: widget.idKunjungan,
                  idPetugas: widget.idPetugas,
                ),
                CpptPasienWidget(
                  idKunjungan: widget.idKunjungan,
                  idPetugas: widget.idPetugas,
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, -2.0),
                )
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: TabBar(
                labelColor: kPrimaryColor,
                unselectedLabelColor: Colors.grey[300],
                indicator: BoxDecoration(color: Colors.red[50]),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.paste),
                    text: 'Rekam Medis',
                    height: 82,
                  ),
                  Tab(
                    icon: Icon(Icons.apps),
                    text: 'CPPT',
                    height: 82,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TilePemeriksaanFisik extends StatelessWidget {
  const TilePemeriksaanFisik({
    super.key,
    this.title,
    this.subtitle,
  });

  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      minVerticalPadding: 8,
      title: Text(
        '$title',
        style: TextStyle(fontSize: 13.0, color: Colors.grey[400]),
      ),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.arrow_right_rounded,
            color: Colors.grey,
          ),
          Text(
            '$subtitle',
            style: const TextStyle(fontSize: 15.0),
          ),
        ],
      ),
    );
  }
}

class TilePemeriksaanWidget extends StatelessWidget {
  const TilePemeriksaanWidget({
    super.key,
    this.title,
    this.subtitle,
  });
  final String? title;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title',
          style: const TextStyle(fontSize: 13.0, color: Colors.grey),
        ),
        const SizedBox(
          height: 6.0,
        ),
        subtitle ?? const SizedBox(),
      ],
    );
  }
}

class CardResumeWidget extends StatelessWidget {
  const CardResumeWidget({
    super.key,
    this.title,
    this.body,
  });

  final String? title;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2.0, 2.0),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              '$title',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(
            height: 0,
          ),
          body ?? const SizedBox(),
        ],
      ),
    );
  }
}

class ListDataPemeriksaan extends StatelessWidget {
  const ListDataPemeriksaan({
    super.key,
    this.data,
  });

  final String? data;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.arrow_right_rounded,
          color: Colors.grey,
        ),
        Expanded(child: Text('$data')),
      ],
    );
  }
}
