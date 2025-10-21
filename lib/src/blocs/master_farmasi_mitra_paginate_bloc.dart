import 'dart:async';

import 'package:admin_dokter_panggil/src/models/master_farmasi_paginate_model.dart';
import 'package:admin_dokter_panggil/src/repositories/master_farmasi_mitra_paginate_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MasterFarmasiMitraPaginateBloc {
  final _repo = MasterFarmasiMitraPaginateRepo();
  MasterFarmasiPaginateModel? masterFarmasi;
  int initialPage = 1;
  int nextPage = 1;
  StreamController<ApiResponse<MasterFarmasiPaginateModel>>?
      _streamMasterFarmasiMitra;
  final BehaviorSubject<int> _idMitra = BehaviorSubject();
  StreamSink<int> get idMitraSink => _idMitra.sink;
  StreamSink<ApiResponse<MasterFarmasiPaginateModel>>
      get masterFarmasiMitraSink => _streamMasterFarmasiMitra!.sink;
  Stream<ApiResponse<MasterFarmasiPaginateModel>>
      get masterFarmasiMitraStream => _streamMasterFarmasiMitra!.stream;

  Future<void> getFarmasiMitra() async {
    _streamMasterFarmasiMitra = StreamController();
    final idMitra = _idMitra.value;
    masterFarmasiMitraSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getFarmasiMitra(initialPage, idMitra);
      if (_streamMasterFarmasiMitra!.isClosed) return;
      masterFarmasi = res;
      nextPage = 1;
      masterFarmasiMitraSink.add(ApiResponse.completed(masterFarmasi));
    } catch (e) {
      if (_streamMasterFarmasiMitra!.isClosed) return;
      masterFarmasiMitraSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getFarmasiMitraNext() async {
    nextPage = nextPage + 1;
    final idMitra = _idMitra.value;
    try {
      final res = await _repo.getFarmasiMitra(nextPage, idMitra);
      masterFarmasi!.currentPage = nextPage;
      masterFarmasi!.barangFarmasi!.addAll(res.barangFarmasi!);
      masterFarmasiMitraSink.add(ApiResponse.completed(masterFarmasi));
    } catch (e) {
      if (_streamMasterFarmasiMitra!.isClosed) return;
      masterFarmasiMitraSink.add(ApiResponse.completed(masterFarmasi));
    }
  }

  void dispose() {
    _streamMasterFarmasiMitra?.close();
    _idMitra.close();
  }
}
