import 'dart:async';

import 'package:admin_dokter_panggil/src/models/master_bhp_model.dart';
import 'package:admin_dokter_panggil/src/repositories/master_bhp_delete_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/master_bhp_save_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/master_bhp_update_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MasterBhpBloc {
  late MasterBhpSaveRepo _repo;
  late MasterBhpUpdateRepo _repoUpdate;
  late MasterBhpDeleteRepo _repoDelete;
  StreamController<ApiResponse<ResponseMasterBhpModel>>? _streamMasterBhp;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<String> _nama = BehaviorSubject();
  final BehaviorSubject<String> _minStok = BehaviorSubject();
  final BehaviorSubject<String> _harga = BehaviorSubject();
  final BehaviorSubject<String> _jasa = BehaviorSubject();
  final BehaviorSubject<int> _kategori = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<String> get namaSink => _nama.sink;
  StreamSink<String> get minStokSink => _minStok.sink;
  StreamSink<String> get hargaSink => _harga.sink;
  StreamSink<String> get jasaSink => _jasa.sink;
  StreamSink<int> get kategoriSink => _kategori.sink;
  StreamSink<ApiResponse<ResponseMasterBhpModel>> get masterBhpSink =>
      _streamMasterBhp!.sink;
  Stream<ApiResponse<ResponseMasterBhpModel>> get masterBhpStream =>
      _streamMasterBhp!.stream;

  Future<void> saveMasterBhp() async {
    _repo = MasterBhpSaveRepo();
    _streamMasterBhp = StreamController();
    final nama = _nama.value;
    final minStok = _minStok.value;
    final harga = _harga.value;
    final jasa = _jasa.value;
    final kategori = _kategori.value;
    masterBhpSink.add(ApiResponse.loading('Memuat...'));
    MasterBhpModel masterBhpModel = MasterBhpModel(
      namaBarang: nama,
      minStock: int.parse(minStok),
      hargaModal: int.parse(harga),
      jasa: int.parse(jasa),
      kategori: kategori,
    );
    try {
      final res = await _repo.saveBhp(masterBhpModel);
      if (_streamMasterBhp!.isClosed) return;
      masterBhpSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterBhp!.isClosed) return;
      masterBhpSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> updateMasterBhp() async {
    _repoUpdate = MasterBhpUpdateRepo();
    _streamMasterBhp = StreamController();
    final id = _id.value;
    final nama = _nama.value;
    final minStok = _minStok.value;
    final harga = _harga.value;
    final jasa = _jasa.value;
    final kategori = _kategori.value;
    masterBhpSink.add(ApiResponse.loading('Memuat...'));
    MasterBhpModel masterBhpModel = MasterBhpModel(
      namaBarang: nama,
      minStock: int.parse(minStok),
      hargaModal: int.parse(harga),
      jasa: int.parse(jasa),
      kategori: kategori,
    );
    try {
      final res = await _repoUpdate.updateMasterBhp(id, masterBhpModel);
      if (_streamMasterBhp!.isClosed) return;
      masterBhpSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterBhp!.isClosed) return;
      masterBhpSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> deleteMasterBhp() async {
    _repoDelete = MasterBhpDeleteRepo();
    _streamMasterBhp = StreamController();
    final id = _id.value;
    masterBhpSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repoDelete.deleteMasterBhp(id);
      if (_streamMasterBhp!.isClosed) return;
      masterBhpSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterBhp!.isClosed) return;
      masterBhpSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamMasterBhp?.close();
    _nama.close();
    _minStok.close();
    _harga.close();
    _jasa.close();
  }
}
