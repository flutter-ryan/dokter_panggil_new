import 'dart:async';

import 'package:admin_dokter_panggil/src/models/master_jabatan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/master_jabatan_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';

class MasterJabatanBloc {
  final _repo = MasterJabatanRepo();
  StreamController<ApiResponse<MasterJabatanModel>>? _streamMasterJabatan;
  StreamSink<ApiResponse<MasterJabatanModel>> get masterJabatanSink =>
      _streamMasterJabatan!.sink;
  Stream<ApiResponse<MasterJabatanModel>> get masterJabatanStream =>
      _streamMasterJabatan!.stream;

  Future<void> getMasterJabatan() async {
    _streamMasterJabatan = StreamController();
    masterJabatanSink.add(ApiResponse.loading('Loading...'));
    try {
      final res = await _repo.getJabatan();
      if (_streamMasterJabatan!.isClosed) return;
      masterJabatanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterJabatan!.isClosed) return;
      masterJabatanSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamMasterJabatan?.close();
  }
}
