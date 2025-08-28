import 'dart:async';

import 'package:dokter_panggil/src/models/master_ruangan_model.dart';
import 'package:dokter_panggil/src/repositories/master_ruangan_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';

class MasterRuanganBloc {
  final _repo = MasterRuanganRepo();
  StreamController<ApiResponse<MasterRuanganModel>>? _streamMasterRuangan;
  StreamSink<ApiResponse<MasterRuanganModel>> get masterRuanganSink =>
      _streamMasterRuangan!.sink;
  Stream<ApiResponse<MasterRuanganModel>> get masterRuanganStream =>
      _streamMasterRuangan!.stream;

  Future<void> getMasterRuangan() async {
    _streamMasterRuangan = StreamController();
    masterRuanganSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getMasterRuangan();
      if (_streamMasterRuangan!.isClosed) return;
      masterRuanganSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterRuangan!.isClosed) return;
      masterRuanganSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamMasterRuangan?.close();
  }
}
