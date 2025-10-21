import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/tagihan/list_tagihan_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FinalTagihanPage extends StatefulWidget {
  const FinalTagihanPage({
    super.key,
    this.data,
    this.finalTagihan = true,
    this.type,
  });
  final DetailKunjungan? data;
  final bool finalTagihan;
  final String? type;

  @override
  State<FinalTagihanPage> createState() => _FinalTagihanPageState();
}

class _FinalTagihanPageState extends State<FinalTagihanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Final Tagihan'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        ),
        elevation: 0,
      ),
      body: ListTagihanWidget(
        data: widget.data,
        finalTagihan: widget.finalTagihan,
        type: widget.type!,
      ),
    );
  }
}
