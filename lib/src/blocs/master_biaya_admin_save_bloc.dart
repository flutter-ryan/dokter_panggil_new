import 'dart:async';

import 'package:dokter_panggil/src/models/master_biaya_admin_save_model.dart';
import 'package:dokter_panggil/src/repositories/master_biaya_admin_save_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MasterBiayaAdminSaveBloc {
  final _repo = MasterBiayaAdminSaveRepo();
  StreamController<ApiResponse<ResponseMasterBiayaAdminSaveModel>>?
      _streamBiayaAdminSave;
  final BehaviorSubject<String> _deskripsi = BehaviorSubject();
  final BehaviorSubject<int> _nilai = BehaviorSubject();
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<String> _jenis = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<String> get deskripsiSink => _deskripsi.sink;
  StreamSink<int> get nilaiSink => _nilai.sink;
  StreamSink<String> get jenisSink => _jenis.sink;
  StreamSink<ApiResponse<ResponseMasterBiayaAdminSaveModel>>
      get biayaAdminSaveSink => _streamBiayaAdminSave!.sink;
  Stream<ApiResponse<ResponseMasterBiayaAdminSaveModel>>
      get biayaAdminSaveStream => _streamBiayaAdminSave!.stream;

  Future<void> saveBiayaAdmin() async {
    _streamBiayaAdminSave = StreamController();
    final deskripsi = _deskripsi.value;
    final nilai = _nilai.value;
    final jenis = _jenis.value;
    biayaAdminSaveSink.add(ApiResponse.loading('Memuat...'));
    MasterBiayaAdminSaveModel masterBiayaAdminSaveModel =
        MasterBiayaAdminSaveModel(
            deskripsi: deskripsi, nilai: nilai, jenis: jenis);
    try {
      final res = await _repo.saveBiayaAdmin(masterBiayaAdminSaveModel);
      if (_streamBiayaAdminSave!.isClosed) return;
      biayaAdminSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamBiayaAdminSave!.isClosed) return;
      biayaAdminSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> updateBiayaAdmin() async {
    _streamBiayaAdminSave = StreamController();
    final id = _id.value;
    final deskripsi = _deskripsi.value;
    final nilai = _nilai.value;
    final jenis = _jenis.value;
    biayaAdminSaveSink.add(ApiResponse.loading('Memuat...'));
    MasterBiayaAdminSaveModel masterBiayaAdminSaveModel =
        MasterBiayaAdminSaveModel(
            deskripsi: deskripsi, nilai: nilai, jenis: jenis);
    try {
      final res = await _repo.updateBiayaAdmin(masterBiayaAdminSaveModel, id);
      if (_streamBiayaAdminSave!.isClosed) return;
      biayaAdminSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamBiayaAdminSave!.isClosed) return;
      biayaAdminSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> deleteBiayaAdmin() async {
    _streamBiayaAdminSave = StreamController();
    final id = _id.value;
    biayaAdminSaveSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deleteBiayaAdmin(id);
      if (_streamBiayaAdminSave!.isClosed) return;
      biayaAdminSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamBiayaAdminSave!.isClosed) return;
      biayaAdminSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamBiayaAdminSave?.close();
    _id.close();
    _deskripsi.close();
    _nilai.close();
    _jenis.close();
  }
}
