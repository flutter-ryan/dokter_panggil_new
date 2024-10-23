import 'dart:async';

import 'package:dokter_panggil/src/models/kunjunga_pasien_all_model.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/repositories/riwayat_kunjungan_all_repo.dart';

class KunjunganRiwayatAllBloc {
  KunjunganPasienAllModel? kunjungan;
  int initialPage = 1;
  int nextPage = 1;
  int totalPage = 1;
  final _repo = RiwayatKunjunganAllRepo();
  StreamController<ApiResponse<KunjunganPasienAllModel>>?
      _streamRiwayatKunjungan;
  StreamSink<ApiResponse<KunjunganPasienAllModel>>
      get riwayatKunjunganAllSink => _streamRiwayatKunjungan!.sink;
  Stream<ApiResponse<KunjunganPasienAllModel>> get riwayatKunjunganAllStream =>
      _streamRiwayatKunjungan!.stream;

  Future<void> getRiwayatKunjuganAll() async {
    _streamRiwayatKunjungan = StreamController();
    riwayatKunjunganAllSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getRiwayatKunjunganAll(initialPage);
      if (_streamRiwayatKunjungan!.isClosed) return;
      kunjungan = res;
      nextPage = 1;
      riwayatKunjunganAllSink.add(ApiResponse.completed(kunjungan));
    } catch (e) {
      if (_streamRiwayatKunjungan!.isClosed) return;
      riwayatKunjunganAllSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getNextRiwayatAll() async {
    if (nextPage != totalPage) {
      nextPage = nextPage + 1;
      try {
        final res = await _repo.getRiwayatKunjunganAll(nextPage);
        if (_streamRiwayatKunjungan!.isClosed) return;
        kunjungan!.currentPage = nextPage;
        kunjungan!.data!.addAll(res.data!);
        riwayatKunjunganAllSink.add(ApiResponse.completed(kunjungan));
      } catch (e) {
        if (_streamRiwayatKunjungan!.isClosed) return;
        riwayatKunjunganAllSink.add(ApiResponse.completed(kunjungan));
      }
    }
  }

  dispose() {
    _streamRiwayatKunjungan?.close();
  }
}
