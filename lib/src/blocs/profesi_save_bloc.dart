import 'dart:async';

import 'package:dokter_panggil/src/models/profesi_save_model.dart';
import 'package:dokter_panggil/src/repositories/profesi_delete_repo.dart';
import 'package:dokter_panggil/src/repositories/profesi_save_repo.dart';
import 'package:dokter_panggil/src/repositories/profesi_update_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class ProfesiSaveBloc {
  late ProfesiSaveRepo _repo;
  late ProfesiUpdateRepo _repoUpdate;
  late ProfesiDeleteRepo _repoDelete;
  StreamController<ApiResponse<ResponseProfesiSaveModel>>? _streamProfesiSave;

  final BehaviorSubject<String> _profesi = BehaviorSubject();
  final BehaviorSubject<int> _group = BehaviorSubject();
  final BehaviorSubject<int> _id = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<int> get groupSink => _group.sink;
  StreamSink<String> get profesiSink => _profesi.sink;
  StreamSink<ApiResponse<ResponseProfesiSaveModel>> get profesiSaveSink =>
      _streamProfesiSave!.sink;
  Stream<ApiResponse<ResponseProfesiSaveModel>> get profesiSaveStream =>
      _streamProfesiSave!.stream;

  Future<void> saveProfesi() async {
    _repo = ProfesiSaveRepo();
    _streamProfesiSave = StreamController();
    final profesi = _profesi.value;
    final group = _group.value;
    profesiSaveSink.add(ApiResponse.loading('Memuat...'));
    ProfesiSaveModel profesiSaveModel =
        ProfesiSaveModel(profesi: profesi, group: group);
    try {
      final res = await _repo.saveProfesi(profesiSaveModel);
      if (_streamProfesiSave!.isClosed) return;
      profesiSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamProfesiSave!.isClosed) return;
      profesiSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> updateProfesi() async {
    _repoUpdate = ProfesiUpdateRepo();
    _streamProfesiSave = StreamController();
    final id = _id.value;
    final profesi = _profesi.value;
    final group = _group.value;
    profesiSaveSink.add(ApiResponse.loading('Memuat...'));
    ProfesiSaveModel profesiSaveModel =
        ProfesiSaveModel(profesi: profesi, group: group);
    try {
      final res = await _repoUpdate.updateProfesi(id, profesiSaveModel);
      if (_streamProfesiSave!.isClosed) return;
      profesiSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamProfesiSave!.isClosed) return;
      profesiSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> deleteProfesi() async {
    _repoDelete = ProfesiDeleteRepo();
    _streamProfesiSave = StreamController();
    final id = _id.value;
    profesiSaveSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repoDelete.deleteProfesi(id);
      if (_streamProfesiSave!.isClosed) return;
      profesiSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamProfesiSave!.isClosed) return;
      profesiSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamProfesiSave?.close();
    _profesi.close();
    _group.close();
  }
}
