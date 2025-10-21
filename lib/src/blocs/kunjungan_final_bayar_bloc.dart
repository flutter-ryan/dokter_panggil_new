import 'dart:async';

import 'package:admin_dokter_panggil/src/models/kunjungan_final_model.dart';
import 'package:admin_dokter_panggil/src/repositories/kunjungan_final_bayar_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class KunjunganFinalBayarBloc {
  final _repo = KunjunganFinalBayarRepo();
  StreamController<ApiResponse<ResponseKunjunganFinalModel>>?
      _streamKunjunganFinal;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<List<String>> _biaya = BehaviorSubject();
  final BehaviorSubject<List<int>> _nilai = BehaviorSubject();
  final BehaviorSubject<String> _idDiskon = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _totalDiskon = BehaviorSubject.seeded('');
  StreamSink<int> get idSink => _id.sink;
  StreamSink<List<String>> get biayaSink => _biaya.sink;
  StreamSink<List<int>> get nilaiSink => _nilai.sink;
  StreamSink<String> get idDiskonSink => _idDiskon.sink;
  StreamSink<String> get totalDiskon => _totalDiskon.sink;
  StreamSink<ApiResponse<ResponseKunjunganFinalModel>> get kunjunganFinalSink =>
      _streamKunjunganFinal!.sink;
  Stream<ApiResponse<ResponseKunjunganFinalModel>> get kunjunganFinalStream =>
      _streamKunjunganFinal!.stream;
  Future<void> finalBayar() async {
    _streamKunjunganFinal = StreamController();
    final idKunjungan = _id.value;
    final biaya = _biaya.value;
    final nilai = _nilai.value;
    final diskon = _idDiskon.value;
    final totalDiskon = _totalDiskon.value;
    kunjunganFinalSink.add(ApiResponse.loading('Memuat...'));
    KunjunganFinalModel kunjunganFinalModel = KunjunganFinalModel(
      idKunjungan: idKunjungan,
      biaya: biaya,
      nilai: nilai,
      diskon: diskon,
      totalDiskon: totalDiskon,
    );
    try {
      final res = await _repo.finalBayarKunjungan(kunjunganFinalModel);
      if (_streamKunjunganFinal!.isClosed) return;
      kunjunganFinalSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamKunjunganFinal!.isClosed) return;
      kunjunganFinalSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamKunjunganFinal?.close();
    _id.close();
    _biaya.close();
    _nilai.close();
  }
}
