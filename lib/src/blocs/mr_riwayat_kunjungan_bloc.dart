import 'dart:async';

import 'package:admin_dokter_panggil/src/models/mr_riwayat_kunjungan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/mr_riwayat_kunjungan_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MrRiwayatKunjunganBloc {
  MrRiwayatKunjunganModel? mrRiwayatKunjunganModel;
  int page = 1;
  final _repo = MrRiwayatKunjunganRepo();
  StreamController<ApiResponse<MrRiwayatKunjunganModel>>?
      _streamRiwayatKunjungan;

  final BehaviorSubject<String> _norm = BehaviorSubject();
  StreamSink<String> get normSink => _norm.sink;
  StreamSink<ApiResponse<MrRiwayatKunjunganModel>> get riwayatKunjunganSink =>
      _streamRiwayatKunjungan!.sink;
  Stream<ApiResponse<MrRiwayatKunjunganModel>> get riwayatKunjunganStream =>
      _streamRiwayatKunjungan!.stream;

  Future<void> getRiwayatKunjungan() async {
    _streamRiwayatKunjungan = StreamController();
    final norm = _norm.value;
    riwayatKunjunganSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getRiwayatKunjungan(norm, page);
      if (_streamRiwayatKunjungan!.isClosed) return;
      mrRiwayatKunjunganModel = res;
      page += 1;
      riwayatKunjunganSink.add(ApiResponse.completed(mrRiwayatKunjunganModel));
    } catch (e) {
      if (_streamRiwayatKunjungan!.isClosed) return;
      riwayatKunjunganSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getRiwayatNextPage() async {
    final norm = _norm.value;
    riwayatKunjunganSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getRiwayatKunjungan(norm, page);
      if (_streamRiwayatKunjungan!.isClosed) return;
      mrRiwayatKunjunganModel = res;
      page += 1;
      riwayatKunjunganSink.add(ApiResponse.completed(mrRiwayatKunjunganModel));
    } catch (e) {
      if (_streamRiwayatKunjungan!.isClosed) return;
      riwayatKunjunganSink.add(ApiResponse.completed(mrRiwayatKunjunganModel));
    }
  }

  void dispose() {
    _streamRiwayatKunjungan?.close();
    _norm.close();
  }
}
