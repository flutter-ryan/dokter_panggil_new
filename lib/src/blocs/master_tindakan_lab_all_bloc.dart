import 'dart:async';

import 'package:dokter_panggil/src/models/master_tindakan_lab_all_model.dart';
import 'package:dokter_panggil/src/repositories/master_tindakan_lab_all_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';

class MasterTindakanLabAllBloc {
  final _repo = MasterTindakanLabAllRepo();
  StreamController<ApiResponse<MasterTindakanLabAllModel>>?
      _streamTindakanLabAll;
  StreamSink<ApiResponse<MasterTindakanLabAllModel>> get tindakanLabAllSink =>
      _streamTindakanLabAll!.sink;
  Stream<ApiResponse<MasterTindakanLabAllModel>> get tindakanLabAllStream =>
      _streamTindakanLabAll!.stream;
  Future<void> getTindakanLabAll() async {
    _streamTindakanLabAll = StreamController();
    tindakanLabAllSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getMasterTindakanLab();
      if (_streamTindakanLabAll!.isClosed) return;
      tindakanLabAllSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTindakanLabAll!.isClosed) return;
      tindakanLabAllSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getTindakanLabNonKonsul() async {
    _streamTindakanLabAll = StreamController();
    tindakanLabAllSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getTindakanLabNonkonsul();
      if (_streamTindakanLabAll!.isClosed) return;
      tindakanLabAllSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTindakanLabAll!.isClosed) return;
      tindakanLabAllSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamTindakanLabAll?.close();
  }
}
