import 'dart:async';
import 'package:admin_dokter_panggil/src/models/mr_kunjungan_observasi_anak_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_kunjungan_observasi_model.dart';
import 'package:admin_dokter_panggil/src/repositories/mr_kunjungan_observasi_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MrKunjunganObservasiBloc {
  final _repo = MrKunjunganObservasiRepo();
  StreamController<ApiResponse<MrKunjunganObservasiModel>>? _streamObservasi;
  StreamController<ApiResponse<MrKunjunganObservasiAnakModel>>?
      _streamObservasiAnak;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<ApiResponse<MrKunjunganObservasiModel>> get observasiSink =>
      _streamObservasi!.sink;
  Stream<ApiResponse<MrKunjunganObservasiModel>> get observasiStream =>
      _streamObservasi!.stream;

  StreamSink<ApiResponse<MrKunjunganObservasiAnakModel>>
      get observasiAnakSink => _streamObservasiAnak!.sink;
  Stream<ApiResponse<MrKunjunganObservasiAnakModel>> get observasiAnakStream =>
      _streamObservasiAnak!.stream;

  Future<void> getObservasi() async {
    _streamObservasi = StreamController();
    final idKunjungan = _idKunjungan.value;
    observasiSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getObservasi(idKunjungan);
      if (_streamObservasi!.isClosed) return;
      observasiSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamObservasi!.isClosed) return;
      observasiSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getObservasiAnak() async {
    _streamObservasiAnak = StreamController();
    final idKunjungan = _idKunjungan.value;
    observasiAnakSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getObservasiAnak(idKunjungan);
      if (_streamObservasiAnak!.isClosed) return;
      observasiAnakSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamObservasiAnak!.isClosed) return;
      observasiAnakSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamObservasi?.close();
    _streamObservasiAnak?.close();
    _idKunjungan.close();
  }
}
