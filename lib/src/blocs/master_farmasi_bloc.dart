import 'dart:async';

import 'package:dokter_panggil/src/models/master_farmasi_model.dart';
import 'package:dokter_panggil/src/repositories/master_farmasi_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MasterFarmasiBloc {
  final _repo = MasterFarmasiRepo();
  StreamController<ApiResponse<ResponseMasterFarmasiModel>>?
      _streamMasterFarmasi;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<String> _barang = BehaviorSubject();
  final BehaviorSubject<int> _harga = BehaviorSubject();
  final BehaviorSubject<String> _persen = BehaviorSubject();
  final BehaviorSubject<int> _mitra = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<String> get barangSink => _barang.sink;
  StreamSink<int> get hargaSink => _harga.sink;
  StreamSink<String> get persenSink => _persen.sink;
  StreamSink<int> get mitraSink => _mitra.sink;
  StreamSink<ApiResponse<ResponseMasterFarmasiModel>> get masterFarmasiSink =>
      _streamMasterFarmasi!.sink;
  Stream<ApiResponse<ResponseMasterFarmasiModel>> get masterFarmasiStream =>
      _streamMasterFarmasi!.stream;

  Future<void> saveMasterFarmasi() async {
    _streamMasterFarmasi = StreamController();
    final barang = _barang.value;
    final harga = _harga.value;
    final persen = _persen.value;
    final mitra = _mitra.value;

    masterFarmasiSink.add(ApiResponse.loading('Memuat...'));
    MasterFarmasiModel masterFarmasiModel = MasterFarmasiModel(
        barang: barang, harga: harga, persen: persen, mitra: mitra);
    try {
      final res = await _repo.saveFarmasi(masterFarmasiModel);
      if (_streamMasterFarmasi!.isClosed) return;
      masterFarmasiSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterFarmasi!.isClosed) return;
      masterFarmasiSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> updateMasterFarmasi() async {
    _streamMasterFarmasi = StreamController();
    final id = _id.value;
    final barang = _barang.value;
    final harga = _harga.value;
    final persen = _persen.value;
    final mitra = _mitra.value;

    masterFarmasiSink.add(ApiResponse.loading('Memuat...'));
    MasterFarmasiModel masterFarmasiModel = MasterFarmasiModel(
        barang: barang, harga: harga, persen: persen, mitra: mitra);
    try {
      final res = await _repo.updateFarmasi(id, masterFarmasiModel);
      if (_streamMasterFarmasi!.isClosed) return;
      masterFarmasiSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterFarmasi!.isClosed) return;
      masterFarmasiSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> deleteMasterFarmasi() async {
    _streamMasterFarmasi = StreamController();
    final id = _id.value;
    masterFarmasiSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deleteFarmasi(id);
      if (_streamMasterFarmasi!.isClosed) return;
      masterFarmasiSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterFarmasi!.isClosed) return;
      masterFarmasiSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamMasterFarmasi?.close();
    _barang.close();
    _harga.close();
    _persen.close();
    _mitra.close();
  }
}
