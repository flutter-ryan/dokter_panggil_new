import 'dart:async';

import 'package:admin_dokter_panggil/src/models/kunjungan_riwayat_model.dart';
import 'package:admin_dokter_panggil/src/repositories/kunjungan_riwayat_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';

class KunjunganRiwayatBloc {
  final KunjunganRiwayatRepo _repo = KunjunganRiwayatRepo();
  StreamController<ApiResponse<KunjunganRiwayatModel>>? _streamKunjunganRiwayat;
  StreamSink<ApiResponse<KunjunganRiwayatModel>> get kunjunganRiwayatSink =>
      _streamKunjunganRiwayat!.sink;
  Stream<ApiResponse<KunjunganRiwayatModel>> get kunjunganRiwayatStream =>
      _streamKunjunganRiwayat!.stream;

  Future<void> riwayatKunjungan() async {
    _streamKunjunganRiwayat = StreamController();
    kunjunganRiwayatSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.riwayatKunjungan();
      if (_streamKunjunganRiwayat!.isClosed) return;
      kunjunganRiwayatSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamKunjunganRiwayat!.isClosed) return;
      kunjunganRiwayatSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamKunjunganRiwayat?.close();
  }
}
