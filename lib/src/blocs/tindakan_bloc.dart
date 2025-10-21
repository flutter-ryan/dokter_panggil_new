import 'dart:async';

import 'package:admin_dokter_panggil/src/models/tindakan_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/repositories/tindakan_delete_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/tindakan_save_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/tindakan_update_repo.dart';
import 'package:rxdart/subjects.dart';

class TindakanBloc {
  late TindakanSaveRepo _repo;
  late TindakanUpdateRepo _repoUpdate;
  late TindakanDeleteRepo _repoDelete;
  StreamController<ApiResponse<ResponseTindakanModel>>? _streamMasterTindakan;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<String> _tindakan = BehaviorSubject();
  final BehaviorSubject<int> _tarifTindakan = BehaviorSubject();
  final BehaviorSubject<int> _jasa = BehaviorSubject();
  final BehaviorSubject<bool> _langsung = BehaviorSubject.seeded(false);
  final BehaviorSubject<bool> _transportasi = BehaviorSubject.seeded(false);
  final BehaviorSubject<bool> _gojek = BehaviorSubject.seeded(false);
  final BehaviorSubject<int?> _idGroup = BehaviorSubject.seeded(null);
  final BehaviorSubject<int> _idKategori = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<String> get tindakanSink => _tindakan.sink;
  StreamSink<int> get tarifTindakanSink => _tarifTindakan.sink;
  StreamSink<int> get jasaSink => _jasa.sink;
  StreamSink<bool> get langsungSink => _langsung.sink;
  StreamSink<bool> get transportasiSink => _transportasi.sink;
  StreamSink<bool> get gojekSink => _gojek.sink;
  StreamSink<int?> get idGroupSink => _idGroup.sink;
  StreamSink<int> get idKategoriSink => _idKategori.sink;
  StreamSink<ApiResponse<ResponseTindakanModel>> get masterTindakanSink =>
      _streamMasterTindakan!.sink;
  Stream<ApiResponse<ResponseTindakanModel>> get masterTindakanStream =>
      _streamMasterTindakan!.stream;

  Future<void> tindakanSave() async {
    _repo = TindakanSaveRepo();
    _streamMasterTindakan = StreamController();
    final tindakan = _tindakan.value;
    final tarifTindakan = _tarifTindakan.value;
    final jasa = _jasa.value;
    final langsung = _langsung.value;
    final transportasi = _transportasi.value;
    final gojek = _gojek.value;
    final idGroup = _idGroup.value;
    final idKategori = _idKategori.value;
    masterTindakanSink.add(ApiResponse.loading('Memuat...'));
    TindakanModel tindakanModel = TindakanModel(
      tindakan: tindakan,
      tarifTindakan: tarifTindakan,
      jasaDokter: jasa,
      bayarLangsung: langsung,
      transportasi: transportasi,
      gojek: gojek,
      idGroup: idGroup,
      idKategori: idKategori,
    );

    try {
      final res = await _repo.saveTindakan(tindakanModel);
      if (_streamMasterTindakan!.isClosed) return;
      masterTindakanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterTindakan!.isClosed) return;
      masterTindakanSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> tindakanUpdate() async {
    _repoUpdate = TindakanUpdateRepo();
    _streamMasterTindakan = StreamController();
    final id = _id.value;
    final tindakan = _tindakan.value;
    final tarifTindakan = _tarifTindakan.value;
    final jasa = _jasa.value;
    final langsung = _langsung.value;
    final transportasi = _transportasi.value;
    final gojek = _gojek.value;
    final idGroup = !_idGroup.hasValue ? null : _idGroup.value;
    final idKategori = _idKategori.value;
    masterTindakanSink.add(ApiResponse.loading('Memuat...'));
    TindakanModel tindakanModel = TindakanModel(
      tindakan: tindakan,
      tarifTindakan: tarifTindakan,
      jasaDokter: jasa,
      bayarLangsung: langsung,
      transportasi: transportasi,
      gojek: gojek,
      idGroup: idGroup,
      idKategori: idKategori,
    );
    try {
      final res = await _repoUpdate.updateTindakan(id, tindakanModel);
      if (_streamMasterTindakan!.isClosed) return;
      masterTindakanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterTindakan!.isClosed) return;
      masterTindakanSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> tindakanDelete() async {
    _repoDelete = TindakanDeleteRepo();
    _streamMasterTindakan = StreamController();
    final id = _id.value;
    masterTindakanSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repoDelete.deleteTindakan(id);
      if (_streamMasterTindakan!.isClosed) return;
      masterTindakanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterTindakan!.isClosed) return;
      masterTindakanSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamMasterTindakan?.close();
    _tindakan.close();
    _tarifTindakan.close();
    _jasa.close();
    _langsung.close();
    _transportasi.close();
    _gojek.close();
    _id.close();
    _idKategori.close();
  }
}
