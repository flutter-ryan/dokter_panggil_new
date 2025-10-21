import 'dart:async';

import 'package:admin_dokter_panggil/src/models/kunjunga_pasien_all_model.dart';
import 'package:admin_dokter_panggil/src/repositories/kunjungan_pasien_all_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';

class KunjunganPasienAllBloc {
  KunjunganPasienAllModel? kunjungan;
  int initialPage = 1;
  int totalPage = 0;
  int nextPage = 1;
  final _repo = KunjunganPasienAllRepo();
  StreamController<ApiResponse<KunjunganPasienAllModel>>?
      _streamKunjunganPasien;
  StreamSink<ApiResponse<KunjunganPasienAllModel>> get kunjunganPasienAllSink =>
      _streamKunjunganPasien!.sink;
  Stream<ApiResponse<KunjunganPasienAllModel>> get kunjunganPasienAllStream =>
      _streamKunjunganPasien!.stream;

  Future<void> getPageKunjungan() async {
    _streamKunjunganPasien = StreamController();
    kunjunganPasienAllSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getKunjungan(initialPage);
      if (_streamKunjunganPasien!.isClosed) return;
      kunjungan = res;
      nextPage = 1;
      totalPage = res.totalPage!;
      kunjunganPasienAllSink.add(ApiResponse.completed(kunjungan));
    } catch (e) {
      if (_streamKunjunganPasien!.isClosed) return;
      kunjunganPasienAllSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getNextKunjungan() async {
    if (nextPage != totalPage) {
      nextPage = nextPage + 1;
      try {
        final res = await _repo.getKunjungan(nextPage);
        if (_streamKunjunganPasien!.isClosed) return;
        kunjungan!.currentPage = nextPage;
        kunjungan!.data!.addAll(res.data!);
        kunjunganPasienAllSink.add(ApiResponse.completed(kunjungan));
      } catch (e) {
        if (_streamKunjunganPasien!.isClosed) return;
        kunjunganPasienAllSink.add(ApiResponse.completed(kunjungan));
      }
    }
  }

  void dispose() {
    _streamKunjunganPasien?.close();
  }
}
