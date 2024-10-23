import 'dart:async';

import 'package:dokter_panggil/src/models/master_tindakan_lab_save_model.dart';
import 'package:dokter_panggil/src/repositories/master_tindakan_lab_save_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MasterTindakanLabSaveBloc {
  final _repo = MasterTindakanLabSaveRepo();
  StreamController<ApiResponse<ResponseMasterTindakanLabSaveModel>>?
      _streamTindakanLabSave;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<String> _kode = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _namaTindakanLab = BehaviorSubject();
  final BehaviorSubject<int> _hargaModal = BehaviorSubject();
  final BehaviorSubject<String> _persen = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _mitra = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _jenis = BehaviorSubject.seeded('');
  StreamSink<int> get idSink => _id.sink;
  StreamSink<String> get kodeSink => _kode.sink;
  StreamSink<String> get namaTindakanLabSink => _namaTindakanLab.sink;
  StreamSink<int> get hargaModalSink => _hargaModal.sink;
  StreamSink<String> get persenSink => _persen.sink;
  StreamSink<String> get mitraSink => _mitra.sink;
  StreamSink<String> get jenisSink => _jenis.sink;
  StreamSink<ApiResponse<ResponseMasterTindakanLabSaveModel>>
      get tindakanLabSaveSink => _streamTindakanLabSave!.sink;
  Stream<ApiResponse<ResponseMasterTindakanLabSaveModel>>
      get tindakanLabSaveStream => _streamTindakanLabSave!.stream;

  Future<void> saveTindakanLab() async {
    _streamTindakanLabSave = StreamController();
    final kode = _kode.value;
    final namaTindakanLab = _namaTindakanLab.value;
    final hargaModal = _hargaModal.value;
    final persen = _persen.value;
    final mitra = _mitra.value;
    final jenis = _jenis.value;
    tindakanLabSaveSink.add(ApiResponse.loading('Memuat...'));
    MasterTindakanLabSaveModel masterTindakanLabSaveModel =
        MasterTindakanLabSaveModel(
      kode: kode,
      namaTindakanLab: namaTindakanLab,
      hargaModal: hargaModal,
      persen: persen,
      mitra: mitra,
      jenis: jenis,
    );
    try {
      final res = await _repo.saveTindakanLab(masterTindakanLabSaveModel);
      if (_streamTindakanLabSave!.isClosed) return;
      tindakanLabSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTindakanLabSave!.isClosed) return;
      tindakanLabSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> updateTindakanLab() async {
    _streamTindakanLabSave = StreamController();
    final id = _id.value;
    final kode = _kode.value;
    final namaTindakanLab = _namaTindakanLab.value;
    final hargaModal = _hargaModal.value;
    final persen = _persen.value;
    final mitra = _mitra.value;
    final jenis = _jenis.value;
    tindakanLabSaveSink.add(ApiResponse.loading('Memuat...'));
    MasterTindakanLabSaveModel masterTindakanLabSaveModel =
        MasterTindakanLabSaveModel(
      kode: kode,
      namaTindakanLab: namaTindakanLab,
      hargaModal: hargaModal,
      persen: persen,
      mitra: mitra,
      jenis: jenis,
    );
    try {
      final res = await _repo.updateTindakanLab(masterTindakanLabSaveModel, id);
      if (_streamTindakanLabSave!.isClosed) return;
      tindakanLabSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTindakanLabSave!.isClosed) return;
      tindakanLabSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> deleteTindakanLab() async {
    _streamTindakanLabSave = StreamController();
    final id = _id.value;
    tindakanLabSaveSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deleteTindakanLab(id);
      if (_streamTindakanLabSave!.isClosed) return;
      tindakanLabSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTindakanLabSave!.isClosed) return;
      tindakanLabSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamTindakanLabSave?.close();
    _kode.close();
    _namaTindakanLab.close();
    _hargaModal.close();
    _persen.close();
    _mitra.close();
  }
}
