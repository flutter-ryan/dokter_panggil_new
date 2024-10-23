import 'dart:async';

import 'package:dokter_panggil/src/models/master_tindakan_rad_save_model.dart';
import 'package:dokter_panggil/src/repositories/master_tindakan_rad_save_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MasterTindakanRadSaveBloc {
  final _repo = MasterTindakanRadSaveRepo();
  StreamController<ApiResponse<ResponseMasterTindakanRadSaveModel>>?
      _streamMasterTindakanRadSave;
  final BehaviorSubject<int> _idTindakanRad = BehaviorSubject();
  final BehaviorSubject<String> _namaTindakan = BehaviorSubject();
  final BehaviorSubject<int> _hargaModal = BehaviorSubject();
  final BehaviorSubject<double> _persen = BehaviorSubject();
  StreamSink<int> get idTindakanRadSink => _idTindakanRad.sink;
  StreamSink<String> get namaTindakanSink => _namaTindakan.sink;
  StreamSink<int> get hargaModalSink => _hargaModal.sink;
  StreamSink<double> get persenSink => _persen.sink;
  StreamSink<ApiResponse<ResponseMasterTindakanRadSaveModel>>
      get masterTindakanRadSaveSink => _streamMasterTindakanRadSave!.sink;
  Stream<ApiResponse<ResponseMasterTindakanRadSaveModel>>
      get masterTindakanRadSaveStream => _streamMasterTindakanRadSave!.stream;

  Future<void> saveTindakanRad() async {
    _streamMasterTindakanRadSave = StreamController();
    final namaTindakan = _namaTindakan.value;
    final hargaModal = _hargaModal.value;
    final persen = _persen.value;
    masterTindakanRadSaveSink.add(ApiResponse.loading('Memuat...'));
    MasterTindakanRadSaveModel masterTindakanRadSaveModel =
        MasterTindakanRadSaveModel(
            namaTindakan: namaTindakan, hargaModal: hargaModal, persen: persen);

    try {
      final res = await _repo.saveTindakanRad(masterTindakanRadSaveModel);
      if (_streamMasterTindakanRadSave!.isClosed) return;
      masterTindakanRadSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterTindakanRadSave!.isClosed) return;
      masterTindakanRadSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> updateTindakanRad() async {
    _streamMasterTindakanRadSave = StreamController();
    final idTindakanRad = _idTindakanRad.value;
    final namaTindakan = _namaTindakan.value;
    final hargaModal = _hargaModal.value;
    final persen = _persen.value;
    masterTindakanRadSaveSink.add(ApiResponse.loading('Memuat...'));
    MasterTindakanRadSaveModel masterTindakanRadSaveModel =
        MasterTindakanRadSaveModel(
            namaTindakan: namaTindakan, hargaModal: hargaModal, persen: persen);

    try {
      final res = await _repo.updateTindakanRad(
          masterTindakanRadSaveModel, idTindakanRad);
      if (_streamMasterTindakanRadSave!.isClosed) return;
      masterTindakanRadSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterTindakanRadSave!.isClosed) return;
      masterTindakanRadSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> deleteTindakanRad() async {
    _streamMasterTindakanRadSave = StreamController();
    final idTindakanRad = _idTindakanRad.value;
    masterTindakanRadSaveSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deleteTindakanRad(idTindakanRad);
      if (_streamMasterTindakanRadSave!.isClosed) return;
      masterTindakanRadSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterTindakanRadSave!.isClosed) return;
      masterTindakanRadSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamMasterTindakanRadSave?.close();
    _namaTindakan.close();
    _hargaModal.close();
    _persen.close();
    _idTindakanRad.close();
  }
}
