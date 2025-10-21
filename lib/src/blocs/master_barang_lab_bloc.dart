import 'dart:async';

import 'package:admin_dokter_panggil/src/models/master_barang_lab_model.dart';
import 'package:admin_dokter_panggil/src/repositories/master_barang_lab_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MasterBarangLabBloc {
  List<MasterBarangLab> data = [];
  final _repo = MasterBarangLabRepo();
  StreamController<ApiResponse<List<MasterBarangLab>>>? _streamMasterBarangLab;
  StreamController<ApiResponse<MasterBarangLabModel>>?
      _streamSaveMasterBarangLab;
  StreamController<ApiResponse<ResponseMasterBarangLabModel>>?
      _streamMasterBarangLabSave;
  final BehaviorSubject<int> _barangLab = BehaviorSubject();
  final BehaviorSubject<int> _barang = BehaviorSubject();
  final BehaviorSubject<int> _tindakanLab = BehaviorSubject();
  final BehaviorSubject<List<int>> _tindakanLabs = BehaviorSubject();
  StreamSink<int> get barangLabSink => _barangLab.sink;
  StreamSink<int> get barangSink => _barang.sink;
  StreamSink<int> get tindakanLabSink => _tindakanLab.sink;
  StreamSink<List<int>> get tindakanLabsSink => _tindakanLabs.sink;
  StreamSink<ApiResponse<List<MasterBarangLab>>> get masterBarangLabSink =>
      _streamMasterBarangLab!.sink;
  StreamSink<ApiResponse<MasterBarangLabModel>> get saveMasterBarangLabSink =>
      _streamSaveMasterBarangLab!.sink;
  StreamSink<ApiResponse<ResponseMasterBarangLabModel>>
      get masterBarangLabSaveSink => _streamMasterBarangLabSave!.sink;
  Stream<ApiResponse<List<MasterBarangLab>>> get masterBarangLabStream =>
      _streamMasterBarangLab!.stream;
  Stream<ApiResponse<ResponseMasterBarangLabModel>>
      get masterBarangLabSaveStream => _streamMasterBarangLabSave!.stream;
  Stream<ApiResponse<MasterBarangLabModel>> get saveMasterBarangLabStream =>
      _streamSaveMasterBarangLab!.stream;

  Future<void> getBarangLab() async {
    _streamMasterBarangLab = StreamController();
    masterBarangLabSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getBarangLab();
      if (_streamMasterBarangLab!.isClosed) return;
      data = res.data!;
      masterBarangLabSink.add(ApiResponse.completed(data));
    } catch (e) {
      if (_streamMasterBarangLab!.isClosed) return;
      masterBarangLabSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> saveBarangLab() async {
    _streamSaveMasterBarangLab = StreamController();
    final barang = _barang.value;
    final tindakanLabs = _tindakanLabs.value;
    saveMasterBarangLabSink.add(ApiResponse.loading('Memuat...'));
    MasterBarangLabSaveModel masterBarangLabSaveModel =
        MasterBarangLabSaveModel(barang: barang, tindakanLab: tindakanLabs);
    try {
      final res = await _repo.saveBarangLab(masterBarangLabSaveModel);
      if (_streamSaveMasterBarangLab!.isClosed) return;
      saveMasterBarangLabSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamSaveMasterBarangLab!.isClosed) return;
      saveMasterBarangLabSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> deleteBarangLab() async {
    _streamMasterBarangLabSave = StreamController();
    final idBarangLab = _barangLab.value;
    masterBarangLabSaveSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deleteBarangLab(idBarangLab);
      if (_streamMasterBarangLabSave!.isClosed) return;
      data.removeWhere((e) => e.id == res.data!.id);
      masterBarangLabSaveSink.add(ApiResponse.completed(res));
      if (data.isEmpty) {
        masterBarangLabSink.add(ApiResponse.error('Data tidak tersedia'));
      } else {
        masterBarangLabSink.add(ApiResponse.completed(data));
      }
    } catch (e) {
      if (_streamMasterBarangLabSave!.isClosed) return;
      masterBarangLabSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamMasterBarangLab?.close();
    _streamMasterBarangLabSave?.close();
    _barang.close();
    _tindakanLab.close();
    _tindakanLabs.close();
  }
}
