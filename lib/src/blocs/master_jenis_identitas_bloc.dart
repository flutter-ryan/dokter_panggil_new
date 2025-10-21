import 'dart:async';

import 'package:admin_dokter_panggil/src/models/master_jenis_identitas_model.dart';
import 'package:admin_dokter_panggil/src/repositories/master_jenis_identitas_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';

class MasterJenisIdentitasBloc {
  final _repo = MasterJenisIdentitasRepo();
  StreamController<ApiResponse<MasterJenisIdentitasModel>>?
      _streamMasterJenisIdentitas;

  StreamSink<ApiResponse<MasterJenisIdentitasModel>>
      get masterJenisIdentitasSink => _streamMasterJenisIdentitas!.sink;
  Stream<ApiResponse<MasterJenisIdentitasModel>>
      get masterJenisIdentitasStream => _streamMasterJenisIdentitas!.stream;

  Future<void> getJenisIdentitas() async {
    _streamMasterJenisIdentitas = StreamController();
    masterJenisIdentitasSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getJenisIdentitas();
      if (_streamMasterJenisIdentitas!.isClosed) return;
      masterJenisIdentitasSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterJenisIdentitas!.isClosed) return;
      masterJenisIdentitasSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamMasterJenisIdentitas?.close();
  }
}
