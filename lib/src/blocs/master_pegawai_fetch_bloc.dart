import 'dart:async';

import 'package:dokter_panggil/src/models/master_pegawai_fetch_model.dart';
import 'package:dokter_panggil/src/repositories/master_pegawai_fetch_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';

class MasterPegawaiFetchBloc {
  final _repo = MasterPegawaiFetchRepo();
  StreamController<ApiResponse<MasterPegawaiFetchModel>>? _streamMasterPegawai;
  StreamSink<ApiResponse<MasterPegawaiFetchModel>> get masterPegawaiSink =>
      _streamMasterPegawai!.sink;
  Stream<ApiResponse<MasterPegawaiFetchModel>> get masterPegawaiStream =>
      _streamMasterPegawai!.stream;

  Future<void> getPegawai() async {
    _streamMasterPegawai = StreamController();
    masterPegawaiSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.fetchPegawai();
      if (_streamMasterPegawai!.isClosed) return;
      masterPegawaiSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterPegawai!.isClosed) return;
      masterPegawaiSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamMasterPegawai?.close();
  }
}
