import 'dart:async';

import 'package:dokter_panggil/src/models/update_info_pegawai_model.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/repositories/update_info_pegawai_repo.dart';
import 'package:rxdart/subjects.dart';

class UpdateInfoPegawaiBloc {
  final _repo = UpdateInfoPegawaiRepo();
  StreamController<ApiResponse<ResponseUpdateInfoPegawaiModel>>?
      _streamUpdateInfoPegawai;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<String> _nama = BehaviorSubject();
  final BehaviorSubject<int> _profesi = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<String> get namaSink => _nama.sink;
  StreamSink<int> get profesiSink => _profesi.sink;
  StreamSink<ApiResponse<ResponseUpdateInfoPegawaiModel>>
      get updateInfoPegawaiSink => _streamUpdateInfoPegawai!.sink;
  Stream<ApiResponse<ResponseUpdateInfoPegawaiModel>>
      get updateInfoPegawaiStream => _streamUpdateInfoPegawai!.stream;

  Future<void> updateInfoPegawai() async {
    _streamUpdateInfoPegawai = StreamController();
    final id = _id.value;
    final nama = _nama.value;
    final profesi = _profesi.value;
    updateInfoPegawaiSink.add(ApiResponse.loading('Memuat...'));
    UpdateInfoPegawaiModel updateInfoPegawaiModel =
        UpdateInfoPegawaiModel(nama: nama, profesi: profesi);
    try {
      final res = await _repo.updateInfoPegawai(id, updateInfoPegawaiModel);
      if (_streamUpdateInfoPegawai!.isClosed) return;
      updateInfoPegawaiSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamUpdateInfoPegawai!.isClosed) return;
      updateInfoPegawaiSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _nama.close();
    _profesi.close();
    _id.close();
    _streamUpdateInfoPegawai?.close();
  }
}
