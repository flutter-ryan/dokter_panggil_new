import 'dart:async';

import 'package:admin_dokter_panggil/src/models/master_group_jabatan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/master_group_jabatan_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';

class MasterGroupJabatanBloc {
  final _repo = MasterGroupJabatanRepo();
  StreamController<ApiResponse<MasterGroupJabatanModel>>?
      _streamMasterGroupJabatan;
  StreamSink<ApiResponse<MasterGroupJabatanModel>> get masterGroupJabatanSink =>
      _streamMasterGroupJabatan!.sink;
  Stream<ApiResponse<MasterGroupJabatanModel>> get masterGroupJabatanStream =>
      _streamMasterGroupJabatan!.stream;
  Future<void> getMasterGroupJabatan() async {
    _streamMasterGroupJabatan = StreamController();
    masterGroupJabatanSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getMasterGroupJabatan();
      if (_streamMasterGroupJabatan!.isClosed) return;
      masterGroupJabatanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterGroupJabatan!.isClosed) return;
      masterGroupJabatanSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamMasterGroupJabatan?.close();
  }
}
