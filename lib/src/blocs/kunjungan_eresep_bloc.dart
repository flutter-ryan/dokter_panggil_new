import 'dart:async';

import 'package:dokter_panggil/src/models/kunjungan_eresep_create_model.dart';
import 'package:dokter_panggil/src/models/kunjungan_eresep_model.dart';
import 'package:dokter_panggil/src/repositories/kunjungan_eresep_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class KunjunganEresepBloc {
  final KunjunganEresepRepo _repo = KunjunganEresepRepo();
  StreamController<ApiResponse<KunjunganEresepModel>>? _streamEresep;

  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<int> _idPegawai = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<int> get idPegawaisink => _idPegawai.sink;
  StreamSink<ApiResponse<KunjunganEresepModel>> get eresepSink =>
      _streamEresep!.sink;
  Stream<ApiResponse<KunjunganEresepModel>> get eresepStream =>
      _streamEresep!.stream;

  Future<void> getEresep() async {
    _streamEresep = StreamController();
    final id = _id.value;
    eresepSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getEresep(id);
      if (_streamEresep!.isClosed) return;
      eresepSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamEresep!.isClosed) return;
      eresepSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getEresepNon() async {
    _streamEresep = StreamController();
    final id = _id.value;
    eresepSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getEresepNon(id);
      if (_streamEresep!.isClosed) return;
      eresepSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamEresep!.isClosed) return;
      eresepSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getEresepBaru() async {
    _streamEresep = StreamController();
    final id = _id.value;
    final idPegawai = _idPegawai.value;
    eresepSink.add(ApiResponse.loading('Memuat...'));
    KunjunganEresepCreateModel kunjunganEresepCreateModel =
        KunjunganEresepCreateModel(idPegawai: idPegawai, idKunjungan: id);
    try {
      final res = await _repo.getEresepBaru(kunjunganEresepCreateModel);
      if (_streamEresep!.isClosed) return;
      eresepSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamEresep!.isClosed) return;
      eresepSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getEresepRacikanBaru() async {
    _streamEresep = StreamController();
    final id = _id.value;
    final idPegawai = _idPegawai.value;
    eresepSink.add(ApiResponse.loading('Memuat...'));
    KunjunganEresepCreateModel kunjunganEresepCreateModel =
        KunjunganEresepCreateModel(idPegawai: idPegawai, idKunjungan: id);
    try {
      final res = await _repo.getEresepRacikanBaru(kunjunganEresepCreateModel);
      if (_streamEresep!.isClosed) return;
      eresepSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamEresep!.isClosed) return;
      eresepSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamEresep?.close();
    _id.close();
    _idPegawai.close();
  }
}
