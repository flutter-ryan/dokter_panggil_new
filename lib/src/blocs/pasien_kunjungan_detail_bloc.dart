import 'dart:async';

import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/repositories/pasien_kunjungan_detail_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class PasienKunjunganDetailBloc {
  final PasienKunjunganDetailRepo _repo = PasienKunjunganDetailRepo();
  StreamController<ApiResponse<PasienKunjunganDetailModel>>?
      _streamKunjunganDetail;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<ApiResponse<PasienKunjunganDetailModel>> get kunjunganDetailSink =>
      _streamKunjunganDetail!.sink;
  Stream<ApiResponse<PasienKunjunganDetailModel>> get kunjunganDetailStream =>
      _streamKunjunganDetail!.stream;

  Future<void> kunjunganDetail() async {
    _streamKunjunganDetail = StreamController();
    final idKunjungan = _idKunjungan.value;
    kunjunganDetailSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.detailKunjungan(idKunjungan);
      if (_streamKunjunganDetail!.isClosed) return;
      kunjunganDetailSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamKunjunganDetail!.isClosed) return;
      kunjunganDetailSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamKunjunganDetail?.close();
    _idKunjungan.close();
  }
}
