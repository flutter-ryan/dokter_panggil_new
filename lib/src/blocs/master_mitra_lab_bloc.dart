import 'dart:async';

import 'package:admin_dokter_panggil/src/models/master_mitra_lab_model.dart';
import 'package:admin_dokter_panggil/src/repositories/master_mitra_lab_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';

class MasterMitraLabBloc {
  final _repo = MasterMitraLabRepo();
  StreamController<ApiResponse<MasterMitraLabModel>>? _streamMasterMitraLab;
  StreamSink<ApiResponse<MasterMitraLabModel>> get masterMitraLabSink =>
      _streamMasterMitraLab!.sink;
  Stream<ApiResponse<MasterMitraLabModel>> get masterMitraLabStream =>
      _streamMasterMitraLab!.stream;

  Future<void> getMitraLab() async {
    _streamMasterMitraLab = StreamController();
    masterMitraLabSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getMitraLab();
      if (_streamMasterMitraLab!.isClosed) return;
      masterMitraLabSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterMitraLab!.isClosed) return;
      masterMitraLabSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamMasterMitraLab?.close();
  }
}
