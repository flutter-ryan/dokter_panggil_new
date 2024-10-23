import 'dart:async';

import 'package:dokter_panggil/src/models/master_identitas_model.dart';
import 'package:dokter_panggil/src/repositories/master_identitas_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MasterIdentitasBloc {
  final _repo = MasterIdentitasRepo();
  StreamController<ApiResponse<List<MasterIdentitas>>>? _streamMasterIdentitas;
  StreamController<ApiResponse<ResponseMasterIdentitasRequestModel>>?
      _streamMasterIdentitasSave;
  final BehaviorSubject<int> _idIdentitas = BehaviorSubject();
  final BehaviorSubject<String> _filter = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _jenis = BehaviorSubject();
  StreamSink<int> get idIdentitasSink => _idIdentitas.sink;
  StreamSink<String> get jenisSink => _jenis.sink;
  StreamSink<String> get filterSink => _filter.sink;
  StreamSink<ApiResponse<List<MasterIdentitas>>> get masterIdentitasSink =>
      _streamMasterIdentitas!.sink;
  StreamSink<ApiResponse<ResponseMasterIdentitasRequestModel>>
      get masterIdentitasSaveSink => _streamMasterIdentitasSave!.sink;
  Stream<ApiResponse<List<MasterIdentitas>>> get masterIdentitasStream =>
      _streamMasterIdentitas!.stream;
  Stream<ApiResponse<ResponseMasterIdentitasRequestModel>>
      get masterIdentitasSaveStream => _streamMasterIdentitasSave!.stream;

  Future<void> getMasterIdentitas() async {
    _streamMasterIdentitas = StreamController();
    final filter = _filter.value;
    masterIdentitasSink.add(ApiResponse.loading('Memuat...'));
    MasterIdentitasFilterModel masterIdentitasFilterModel =
        MasterIdentitasFilterModel(filter: filter);
    try {
      final res = await _repo.getMasterIdentitas(masterIdentitasFilterModel);
      if (_streamMasterIdentitas!.isClosed) return;
      masterIdentitasSink.add(ApiResponse.completed(res.data));
    } catch (e) {
      if (_streamMasterIdentitas!.isClosed) return;
      masterIdentitasSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> saveMasterIdentitas() async {
    _streamMasterIdentitasSave = StreamController();
    final jenis = _jenis.value;
    masterIdentitasSaveSink.add(ApiResponse.loading('Memuat...'));
    MasterIdentitasRequestModel masterIdentitasRequestModel =
        MasterIdentitasRequestModel(jenis: jenis);
    try {
      final res = await _repo.saveMasteridentitas(masterIdentitasRequestModel);
      if (_streamMasterIdentitasSave!.isClosed) return;
      masterIdentitasSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterIdentitasSave!.isClosed) return;
      masterIdentitasSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> updateMasterIdentitas() async {
    _streamMasterIdentitasSave = StreamController();
    final jenis = _jenis.value;
    final idIdentitas = _idIdentitas.value;
    masterIdentitasSaveSink.add(ApiResponse.loading('Memuat...'));
    MasterIdentitasRequestModel masterIdentitasRequestModel =
        MasterIdentitasRequestModel(jenis: jenis);
    try {
      final res = await _repo.updateMasterIdentitas(
          masterIdentitasRequestModel, idIdentitas);
      if (_streamMasterIdentitasSave!.isClosed) return;
      masterIdentitasSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterIdentitasSave!.isClosed) return;
      masterIdentitasSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> deleteMasterTindakan() async {
    _streamMasterIdentitasSave = StreamController();
    final idIdentitas = _idIdentitas.value;
    masterIdentitasSaveSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deleteMasterIdentitas(idIdentitas);
      if (_streamMasterIdentitasSave!.isClosed) return;
      masterIdentitasSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterIdentitasSave!.isClosed) return;
      masterIdentitasSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamMasterIdentitas?.close();
    _streamMasterIdentitasSave?.close();
    _jenis.close();
  }
}
