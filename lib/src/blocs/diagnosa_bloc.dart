import 'dart:async';

import 'package:admin_dokter_panggil/src/models/diagnosa_model.dart';
import 'package:admin_dokter_panggil/src/repositories/diagnosa_delete_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/diagnosa_save_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/diagnosa_update_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class DiagnosaBloc {
  late DiagnosaSaveRepo _repo;
  late DiagnosaUpdateRepo _repoUpdate;
  late DiagnosaDeleteRepo _repoDelete;
  StreamController<ApiResponse<ResponseDiagnosaModel>>? _streamMasterDiagnosa;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<String> _diagnosa = BehaviorSubject();
  final BehaviorSubject<String> _kode = BehaviorSubject();

  StreamSink<int> get idSink => _id.sink;
  StreamSink<String> get diagnosaSink => _diagnosa.sink;
  StreamSink<String> get kodeSink => _kode.sink;
  StreamSink<ApiResponse<ResponseDiagnosaModel>> get masterDiagnosaSink =>
      _streamMasterDiagnosa!.sink;
  Stream<ApiResponse<ResponseDiagnosaModel>> get masterDiagnosaStream =>
      _streamMasterDiagnosa!.stream;

  Future<void> saveDiagnosa() async {
    _repo = DiagnosaSaveRepo();
    _streamMasterDiagnosa = StreamController();
    final diagnosa = _diagnosa.value;
    final kode = _kode.value;
    masterDiagnosaSink.add(ApiResponse.loading('Memuat...'));
    DiagnosaModel diagnosaModel = DiagnosaModel(diagnosa: diagnosa, kode: kode);
    try {
      final res = await _repo.saveDiagnosa(diagnosaModel);
      if (_streamMasterDiagnosa!.isClosed) return;
      masterDiagnosaSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterDiagnosa!.isClosed) return;
      masterDiagnosaSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> updateDiagnosa() async {
    _repoUpdate = DiagnosaUpdateRepo();
    _streamMasterDiagnosa = StreamController();
    final id = _id.value;
    final diagnosa = _diagnosa.value;
    final kode = _kode.value;
    masterDiagnosaSink.add(ApiResponse.loading('Memuat...'));
    DiagnosaModel diagnosaModel = DiagnosaModel(diagnosa: diagnosa, kode: kode);
    try {
      final res = await _repoUpdate.updateDiagnosa(id, diagnosaModel);
      if (_streamMasterDiagnosa!.isClosed) return;
      masterDiagnosaSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterDiagnosa!.isClosed) return;
      masterDiagnosaSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> deleteDiagnosa() async {
    _repoDelete = DiagnosaDeleteRepo();
    _streamMasterDiagnosa = StreamController();
    final id = _id.value;
    masterDiagnosaSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repoDelete.deleteDiagnosa(id);
      if (_streamMasterDiagnosa!.isClosed) return;
      masterDiagnosaSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterDiagnosa!.isClosed) return;
      masterDiagnosaSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamMasterDiagnosa?.close();
    _id.close();
    _diagnosa.close();
    _kode.close();
  }
}
