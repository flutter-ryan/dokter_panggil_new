import 'dart:async';

import 'package:admin_dokter_panggil/src/models/kunjungan_resep_model.dart';
import 'package:admin_dokter_panggil/src/repositories/kunjungan_resep_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class KunjunganResepBloc {
  final _repo = KunjunganResepRepo();
  StreamController<ApiResponse<ResponseKunjunganResepModel>>?
      _streamKujunganResep;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  final BehaviorSubject<int> _idDokter = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<int> get idDokterSink => _idDokter.sink;
  StreamSink<ApiResponse<ResponseKunjunganResepModel>> get kunjunganResepSink =>
      _streamKujunganResep!.sink;
  Stream<ApiResponse<ResponseKunjunganResepModel>> get kunjunganResepStream =>
      _streamKujunganResep!.stream;

  Future<void> getKunjunganResep() async {
    _streamKujunganResep = StreamController();
    final idKunjungan = _idKunjungan.value;
    final idDokter = _idDokter.value;
    kunjunganResepSink.add(ApiResponse.loading('Memuat...'));
    KunjunganResepModel kunjunganResepModel =
        KunjunganResepModel(idDokter: idDokter, idKunjungan: idKunjungan);
    try {
      final res = await _repo.getKunjunganResep(kunjunganResepModel);
      if (_streamKujunganResep!.isClosed) return;
      kunjunganResepSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamKujunganResep!.isClosed) return;
      kunjunganResepSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamKujunganResep?.close();
    _idDokter.close();
    _idKunjungan.close();
  }
}
