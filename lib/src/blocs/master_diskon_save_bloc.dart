import 'dart:async';

import 'package:dokter_panggil/src/models/master_diskon_save_model.dart';
import 'package:dokter_panggil/src/repositories/master_diskon_save_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MasterDiskonSaveBloc {
  final _repo = MasterDiskonSaveRepo();
  StreamController<ApiResponse<ResponseMasterDiskonSaveModel>>?
      _streamSaveMasterDiskon;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<String> _deskripsi = BehaviorSubject();
  final BehaviorSubject<String> _nilai = BehaviorSubject();
  final BehaviorSubject<int> _persen = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<String> get deskripsiSink => _deskripsi.sink;
  StreamSink<String> get nilaiSink => _nilai.sink;
  StreamSink<int> get persenSink => _persen.sink;
  StreamSink<ApiResponse<ResponseMasterDiskonSaveModel>>
      get saveMasterDiskonSink => _streamSaveMasterDiskon!.sink;
  Stream<ApiResponse<ResponseMasterDiskonSaveModel>>
      get saveMasterDiskonStream => _streamSaveMasterDiskon!.stream;
  Future<void> saveMasterDiskon() async {
    _streamSaveMasterDiskon = StreamController();
    final deskripsi = _deskripsi.value;
    final nilai = _nilai.value;
    final persen = _persen.value;
    saveMasterDiskonSink.add(ApiResponse.loading('Memuat...'));
    MasterDiskonSaveModel masterDiskonSaveModel = MasterDiskonSaveModel(
        deskripsi: deskripsi, nilai: int.parse(nilai), persen: persen);
    try {
      final res = await _repo.saveMasterDiskon(masterDiskonSaveModel);
      if (_streamSaveMasterDiskon!.isClosed) return;
      saveMasterDiskonSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamSaveMasterDiskon!.isClosed) return;
      saveMasterDiskonSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> updateMasterDiskon() async {
    _streamSaveMasterDiskon = StreamController();
    final id = _id.value;
    final deskripsi = _deskripsi.value;
    final nilai = _nilai.value;
    final persen = _persen.value;
    saveMasterDiskonSink.add(ApiResponse.loading('Memuat...'));
    MasterDiskonSaveModel masterDiskonSaveModel = MasterDiskonSaveModel(
        deskripsi: deskripsi, nilai: int.parse(nilai), persen: persen);
    try {
      final res = await _repo.updateMasterDiskon(masterDiskonSaveModel, id);
      if (_streamSaveMasterDiskon!.isClosed) return;
      saveMasterDiskonSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamSaveMasterDiskon!.isClosed) return;
      saveMasterDiskonSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> deleteMasterDiskon() async {
    _streamSaveMasterDiskon = StreamController();
    final id = _id.value;
    saveMasterDiskonSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deleteMasterDiskon(id);
      if (_streamSaveMasterDiskon!.isClosed) return;
      saveMasterDiskonSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamSaveMasterDiskon!.isClosed) return;
      saveMasterDiskonSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamSaveMasterDiskon?.close();
    _deskripsi.close();
    _nilai.close();
    _persen.close();
  }
}
