import 'dart:async';

import 'package:admin_dokter_panggil/src/models/master_status_nikah_model.dart';
import 'package:admin_dokter_panggil/src/repositories/master_status_nikah_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';

class MasterStatusNikahBloc {
  final _repo = MasterStatusNikahRepo();
  StreamController<ApiResponse<MasterStatusNikahModel>>?
      _streamMasterStatusNikah;
  StreamSink<ApiResponse<MasterStatusNikahModel>> get masterStatusNikahSink =>
      _streamMasterStatusNikah!.sink;
  Stream<ApiResponse<MasterStatusNikahModel>> get masterStatusNikahStream =>
      _streamMasterStatusNikah!.stream;

  Future<void> getMasterStatusNikah() async {
    _streamMasterStatusNikah = StreamController();
    masterStatusNikahSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getStatusNikah();
      if (_streamMasterStatusNikah!.isClosed) return;
      masterStatusNikahSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterStatusNikah!.isClosed) return;
      masterStatusNikahSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamMasterStatusNikah?.close();
  }
}
