import 'dart:async';

import 'package:dokter_panggil/src/models/master_pegawai_save_model.dart';
import 'package:dokter_panggil/src/repositories/master_pegawai_delete_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MasterPegawaiDeleteBloc {
  final _repo = MasterPegawaiDeleteRepo();
  StreamController<ApiResponse<ResponseMasterPegawaiSaveModel>>?
      _streamMasterPegawaiDelete;
  final BehaviorSubject<int> _idPegawai = BehaviorSubject();
  StreamSink<int> get idPegawaiSink => _idPegawai.sink;
  StreamSink<ApiResponse<ResponseMasterPegawaiSaveModel>>
      get masterPegawaiDeleteSink => _streamMasterPegawaiDelete!.sink;
  Stream<ApiResponse<ResponseMasterPegawaiSaveModel>>
      get masterPegawaiDeleteStream => _streamMasterPegawaiDelete!.stream;
  Future<void> deletePegawai() async {
    _streamMasterPegawaiDelete = StreamController();
    final idPegawai = _idPegawai.value;
    masterPegawaiDeleteSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deletePegawai(idPegawai);
      if (_streamMasterPegawaiDelete!.isClosed) return;
      masterPegawaiDeleteSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterPegawaiDelete!.isClosed) return;
      masterPegawaiDeleteSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamMasterPegawaiDelete?.close();
    _idPegawai.close();
  }
}
