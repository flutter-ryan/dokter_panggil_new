import 'dart:async';

import 'package:dokter_panggil/src/models/master_tindakan_lab_create_model.dart';
import 'package:dokter_panggil/src/repositories/master_tindakan_lab_create_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';

class MasterTindakanLabCreateBloc {
  final _repo = MasterTindakanLabCreateRepo();
  StreamController<ApiResponse<MasterTindakanLabCreateModel>>?
      _streamTindakanLabCreate;
  StreamSink<ApiResponse<MasterTindakanLabCreateModel>>
      get tindakanLabCreateSink => _streamTindakanLabCreate!.sink;
  Stream<ApiResponse<MasterTindakanLabCreateModel>>
      get masterTindakanLabCreateStream => _streamTindakanLabCreate!.stream;

  Future<void> getMasterTindakanLab() async {
    _streamTindakanLabCreate = StreamController();
    tindakanLabCreateSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getTindakanLab();
      if (_streamTindakanLabCreate!.isClosed) return;
      tindakanLabCreateSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTindakanLabCreate!.isClosed) return;
      tindakanLabCreateSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getJenisTindakanLab() async {
    _streamTindakanLabCreate = StreamController();
    tindakanLabCreateSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getJenisTindakanLab();
      if (_streamTindakanLabCreate!.isClosed) return;
      tindakanLabCreateSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTindakanLabCreate!.isClosed) return;
      tindakanLabCreateSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamTindakanLabCreate?.close();
  }
}
