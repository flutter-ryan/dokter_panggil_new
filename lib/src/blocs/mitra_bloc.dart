import 'dart:async';

import 'package:admin_dokter_panggil/src/models/mitra_model.dart';
import 'package:admin_dokter_panggil/src/repositories/mitra_delete_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/mitra_save_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/mitra_update_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MitraBloc {
  late MitraSaveRepo _repo;
  late MitraUpdateRepo _repoUpdate;
  late MitraDeleteRepo _repoDelete;
  StreamController<ApiResponse<ResponseMitraModel>>? _streamMasterMitra;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<String> _mitra = BehaviorSubject();
  final BehaviorSubject<String> _kode = BehaviorSubject();
  final BehaviorSubject<String> _jenis = BehaviorSubject();
  final BehaviorSubject<int> _persentase = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<String> get mitraSink => _mitra.sink;
  StreamSink<String> get kodeSink => _kode.sink;
  StreamSink<String> get jenisSink => _jenis.sink;
  StreamSink<int> get persentaseSink => _persentase.sink;
  StreamSink<ApiResponse<ResponseMitraModel>> get masterMitraSink =>
      _streamMasterMitra!.sink;
  Stream<ApiResponse<ResponseMitraModel>> get masterMitraStream =>
      _streamMasterMitra!.stream;
  Future<void> saveMitra() async {
    _repo = MitraSaveRepo();
    _streamMasterMitra = StreamController();
    final mitra = _mitra.value;
    final kode = _kode.value;
    final jenis = _jenis.value;
    final persentase = _persentase.value;
    masterMitraSink.add(ApiResponse.loading('Memuat...'));
    MitraModel mitraModel = MitraModel(
        mitra: mitra, kode: kode, persentase: persentase, jenis: jenis);
    try {
      final res = await _repo.saveMitra(mitraModel);
      if (_streamMasterMitra!.isClosed) return;
      masterMitraSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterMitra!.isClosed) return;
      masterMitraSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> updateMitra() async {
    _repoUpdate = MitraUpdateRepo();
    _streamMasterMitra = StreamController();
    final id = _id.value;
    final mitra = _mitra.value;
    final kode = _kode.value;
    final jenis = _jenis.value;
    final persentase = _persentase.value;
    masterMitraSink.add(ApiResponse.loading('Memuat...'));
    MitraModel mitraModel = MitraModel(
        mitra: mitra, kode: kode, jenis: jenis, persentase: persentase);
    try {
      final res = await _repoUpdate.updateMitra(id, mitraModel);
      if (_streamMasterMitra!.isClosed) return;
      masterMitraSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterMitra!.isClosed) return;
      masterMitraSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> deleteMitra() async {
    _repoDelete = MitraDeleteRepo();
    _streamMasterMitra = StreamController();
    final id = _id.value;
    masterMitraSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repoDelete.deleteMitra(id);
      if (_streamMasterMitra!.isClosed) return;
      masterMitraSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterMitra!.isClosed) return;
      masterMitraSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamMasterMitra?.close();
    _id.close();
    _mitra.close();
    _kode.close();
    _jenis.close();
    _persentase.close();
  }
}
