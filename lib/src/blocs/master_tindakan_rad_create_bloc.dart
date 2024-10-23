import 'dart:async';

import 'package:dokter_panggil/src/models/master_tindakan_rad_create_mode.dart';
import 'package:dokter_panggil/src/repositories/master_tindakan_rad_create_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';

class MasterTindakanRadCreateBloc {
  final _repo = MasterTindakanRadCreateRepo();
  StreamController<ApiResponse<MasterTindakanRadCreateModel>>?
      _streamTindakanRad;
  StreamSink<ApiResponse<MasterTindakanRadCreateModel>> get tindakanRadSink =>
      _streamTindakanRad!.sink;
  Stream<ApiResponse<MasterTindakanRadCreateModel>> get tindakanRadStream =>
      _streamTindakanRad!.stream;

  Future<void> getTindakanRad() async {
    _streamTindakanRad = StreamController();
    tindakanRadSink.add(ApiResponse.loading('Loading...'));
    try {
      final res = await _repo.getTindakanRad();
      if (_streamTindakanRad!.isClosed) return;
      tindakanRadSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTindakanRad!.isClosed) return;
      tindakanRadSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamTindakanRad?.close();
  }
}
