import 'dart:async';

import 'package:admin_dokter_panggil/src/models/master_tindakan_lab_model.dart';
import 'package:admin_dokter_panggil/src/repositories/master_tindakan_lab_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MasterTindakanLabBloc {
  final _repo = MasterTindakanLabRepo();
  StreamController<ApiResponse<MasterTindakanLabModel>>? _streamTindakanLab;
  final BehaviorSubject<int> _idMitra = BehaviorSubject();
  StreamSink<int> get idMitraSink => _idMitra.sink;
  StreamSink<ApiResponse<MasterTindakanLabModel>> get tindakanLabSink =>
      _streamTindakanLab!.sink;
  Stream<ApiResponse<MasterTindakanLabModel>> get tindakanLabStream =>
      _streamTindakanLab!.stream;

  Future<void> getTindakanLab() async {
    _streamTindakanLab = StreamController();
    final idMitra = _idMitra.value;
    tindakanLabSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getTindakanLab(idMitra);
      if (_streamTindakanLab!.isClosed) return;
      tindakanLabSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTindakanLab!.isClosed) return;
      tindakanLabSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamTindakanLab?.close();
    _idMitra.close();
  }
}
