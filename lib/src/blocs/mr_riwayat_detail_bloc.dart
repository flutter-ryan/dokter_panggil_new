import 'dart:async';

import 'package:admin_dokter_panggil/src/models/mr_riwayat_detail_model.dart';
import 'package:admin_dokter_panggil/src/repositories/mr_riwayat_detail_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MrRiwayatDetailBloc {
  final _repo = MrRiwayatDetailRepo();
  StreamController<ApiResponse<MrRiwayatDetailModel>>? _streamRiwayatDetail;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<ApiResponse<MrRiwayatDetailModel>> get riwayatDetailSink =>
      _streamRiwayatDetail!.sink;
  Stream<ApiResponse<MrRiwayatDetailModel>> get riwayatDetailStream =>
      _streamRiwayatDetail!.stream;

  Future<void> getRiwayatDetail() async {
    _streamRiwayatDetail = StreamController();
    final idKunjungan = _idKunjungan.value;
    riwayatDetailSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getDetailRiwayat(idKunjungan);
      if (_streamRiwayatDetail!.isClosed) return;
      riwayatDetailSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamRiwayatDetail!.isClosed) return;
      riwayatDetailSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamRiwayatDetail?.close();
    _idKunjungan.close();
  }
}
