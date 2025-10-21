import 'dart:async';

import 'package:admin_dokter_panggil/src/models/biaya_transportasi_tindakan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/biaya_transportasi_tindakan_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class BiayaTransportasiTindakanBloc {
  final _repo = BiayaTransportasiTindakanRepo();
  StreamController<ApiResponse<BiayaTransportasiTindakanModel>>?
      _streamBiayaTransportasiTindakan;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<String> _jenis = BehaviorSubject();
  final BehaviorSubject<int> _biaya = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<String> get jenisSink => _jenis.sink;
  StreamSink<int> get biayaSink => _biaya.sink;
  StreamSink<ApiResponse<BiayaTransportasiTindakanModel>>
      get biayaTransportasiTindakanSink =>
          _streamBiayaTransportasiTindakan!.sink;
  Stream<ApiResponse<BiayaTransportasiTindakanModel>>
      get biayaTransportasiTindakanStream =>
          _streamBiayaTransportasiTindakan!.stream;
  Future<void> getTransportasiTindakan() async {
    _streamBiayaTransportasiTindakan = StreamController();
    final id = _id.value;
    biayaTransportasiTindakanSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getTransportasiTindakan(id);
      if (_streamBiayaTransportasiTindakan!.isClosed) return;
      biayaTransportasiTindakanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamBiayaTransportasiTindakan!.isClosed) return;
      biayaTransportasiTindakanSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> saveTransportasiTindakan() async {
    _streamBiayaTransportasiTindakan = StreamController();
    final jenis = _jenis.value;
    final biaya = _biaya.value;
    biayaTransportasiTindakanSink.add(ApiResponse.loading('Memuat...'));
    BiayaTransportasiTindakanSaveModel biayaTransportasiTindakanSaveModel =
        BiayaTransportasiTindakanSaveModel(biaya: biaya, jenis: jenis);
    try {
      final res = await _repo
          .saveTransportasiTindakan(biayaTransportasiTindakanSaveModel);
      if (_streamBiayaTransportasiTindakan!.isClosed) return;
      biayaTransportasiTindakanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamBiayaTransportasiTindakan!.isClosed) return;
      biayaTransportasiTindakanSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> updateTransportasiTindakan() async {
    _streamBiayaTransportasiTindakan = StreamController();
    final id = _id.value;
    final biaya = _biaya.value;
    final jenis = _jenis.value;
    biayaTransportasiTindakanSink.add(ApiResponse.loading('Memuat...'));
    BiayaTransportasiTindakanSaveModel biayaTransportasiTindakanSaveModel =
        BiayaTransportasiTindakanSaveModel(biaya: biaya, jenis: jenis);
    try {
      final res = await _repo.updateTransportasiTindakan(
          biayaTransportasiTindakanSaveModel, id);
      if (_streamBiayaTransportasiTindakan!.isClosed) return;
      biayaTransportasiTindakanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamBiayaTransportasiTindakan!.isClosed) return;
      biayaTransportasiTindakanSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> deleteTransportasiTindakan() async {
    _streamBiayaTransportasiTindakan = StreamController();
    final id = _id.value;
    biayaTransportasiTindakanSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deleteTransportasiTindakan(id);
      if (_streamBiayaTransportasiTindakan!.isClosed) return;
      biayaTransportasiTindakanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamBiayaTransportasiTindakan!.isClosed) return;
      biayaTransportasiTindakanSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamBiayaTransportasiTindakan?.close();
    _biaya.close();
    _jenis.close();
    _id.close();
  }
}
