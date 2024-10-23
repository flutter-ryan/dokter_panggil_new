import 'dart:async';

import 'package:dokter_panggil/src/models/kunjungan_resep_racikan_model.dart';
import 'package:dokter_panggil/src/repositories/kunjungan_resep_racikan_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class KunjunganResepRacikanBloc {
  final _repo = KunjunganResepRacikanRepo();
  StreamController<ApiResponse<ResponseKunjunganResepRacikanModel>>?
      _streamKujunganResepRacikan;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  final BehaviorSubject<int> _idDokter = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<int> get idDokterSink => _idDokter.sink;
  StreamSink<ApiResponse<ResponseKunjunganResepRacikanModel>>
      get kunjunganResepRacikanSink => _streamKujunganResepRacikan!.sink;
  Stream<ApiResponse<ResponseKunjunganResepRacikanModel>>
      get kunjunganResepRacikanStream => _streamKujunganResepRacikan!.stream;

  Future<void> getKunjunganResepRacikan() async {
    _streamKujunganResepRacikan = StreamController();
    final idKunjungan = _idKunjungan.value;
    final idDokter = _idDokter.value;
    kunjunganResepRacikanSink.add(ApiResponse.loading('Memuat...'));
    KunjunganResepRacikanModel kunjunganResepRacikanModel =
        KunjunganResepRacikanModel(
            idDokter: idDokter, idKunjungan: idKunjungan);
    try {
      final res =
          await _repo.getKunjunganResepRacikan(kunjunganResepRacikanModel);
      if (_streamKujunganResepRacikan!.isClosed) return;
      kunjunganResepRacikanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamKujunganResepRacikan!.isClosed) return;
      kunjunganResepRacikanSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamKujunganResepRacikan?.close();
    _idDokter.close();
    _idKunjungan.close();
  }
}
