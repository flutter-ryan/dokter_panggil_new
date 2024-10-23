import 'dart:async';

import 'package:dokter_panggil/src/models/master_biaya_admin_model.dart';
import 'package:dokter_panggil/src/repositories/master_biaya_admin_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';

class MasterBiayaAdminBloc {
  final _repo = MasterBiayaAdminRepo();
  StreamController<ApiResponse<MasterBiayaAdminModel>>? _streamMasterBiayaAdmin;
  StreamSink<ApiResponse<MasterBiayaAdminModel>> get masterBiayaAdminSink =>
      _streamMasterBiayaAdmin!.sink;
  Stream<ApiResponse<MasterBiayaAdminModel>> get masterBiayaAdminStream =>
      _streamMasterBiayaAdmin!.stream;
  Future<void> getMasterBiayaAdmin() async {
    _streamMasterBiayaAdmin = StreamController();
    masterBiayaAdminSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.createMasterBiayaAdmin();
      if (_streamMasterBiayaAdmin!.isClosed) return;
      masterBiayaAdminSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterBiayaAdmin!.isClosed) return;
      masterBiayaAdminSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamMasterBiayaAdmin?.close();
  }
}
