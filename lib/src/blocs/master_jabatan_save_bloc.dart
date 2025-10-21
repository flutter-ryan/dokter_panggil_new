import 'dart:async';

import 'package:admin_dokter_panggil/src/models/master_jabatan_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/master_jabatan_save_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MasterJabatanSaveBloc {
  final _repo = MasterJabatanSaveRepo();
  StreamController<ApiResponse<ResponseMasterJabatanSaveModel>>?
      _streamJabatanSave;
  final BehaviorSubject<int> _group = BehaviorSubject();
  final BehaviorSubject<String> _jabatan = BehaviorSubject();
  StreamSink<int> get groupSink => _group.sink;
  StreamSink<String> get jabatanSink => _jabatan.sink;
  StreamSink<ApiResponse<ResponseMasterJabatanSaveModel>> get jabatanSaveSink =>
      _streamJabatanSave!.sink;
  Stream<ApiResponse<ResponseMasterJabatanSaveModel>> get jabatanSaveStream =>
      _streamJabatanSave!.stream;

  Future<void> saveMasterJabatan() async {
    _streamJabatanSave = StreamController();
    final jabatan = _jabatan.value;
    final group = _group.value;
    jabatanSaveSink.add(ApiResponse.loading('Memuat...'));
    MasterJabatanSaveModel masterJabatanSaveModel =
        MasterJabatanSaveModel(jabatan: jabatan, group: group);
    try {
      final res = await _repo.saveMasterJabatan(masterJabatanSaveModel);
      if (_streamJabatanSave!.isClosed) return;
      jabatanSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamJabatanSave!.isClosed) return;
      jabatanSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamJabatanSave?.close();
    _group.close();
    _jabatan.close();
  }
}
