import 'dart:async';

import 'package:dokter_panggil/src/models/master_farmasi_paginate_model.dart';
import 'package:dokter_panggil/src/models/master_farmasi_pencarian_model.dart';
import 'package:dokter_panggil/src/repositories/master_farmasi_pencarian_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MasterFarmasiPencarianBloc {
  MasterFarmasiPaginateModel? masterFarmasi;
  int initialPage = 1;
  int nextPage = 1;
  String? namaBarang;
  final _repo = MasterFarmasiPencarianRepo();
  StreamController<ApiResponse<MasterFarmasiPaginateModel>>?
      _streamPencarianMasterFarmasi;
  final BehaviorSubject<String> _namaBarang = BehaviorSubject();
  StreamSink<String> get namaBarangSink => _namaBarang.sink;
  StreamSink<ApiResponse<MasterFarmasiPaginateModel>>
      get pencarianMasterFarmasiSink => _streamPencarianMasterFarmasi!.sink;
  Stream<ApiResponse<MasterFarmasiPaginateModel>>
      get pencarianMasterFarmasiStream => _streamPencarianMasterFarmasi!.stream;

  Future<void> getPencarianMasterFarmasi() async {
    _streamPencarianMasterFarmasi = StreamController();
    namaBarang = _namaBarang.value;
    pencarianMasterFarmasiSink.add(ApiResponse.loading('Memuat...'));
    MasterFarmasiPencarianModel masterFarmasiPencarianModel =
        MasterFarmasiPencarianModel(namaBarang: namaBarang!);
    try {
      final res = await _repo.getPencarianMasterFarmasi(
          initialPage, masterFarmasiPencarianModel);
      if (_streamPencarianMasterFarmasi!.isClosed) return;
      masterFarmasi = res;
      nextPage = 1;
      pencarianMasterFarmasiSink.add(ApiResponse.completed(masterFarmasi));
    } catch (e) {
      if (_streamPencarianMasterFarmasi!.isClosed) return;
      pencarianMasterFarmasiSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getPencarianMasterFarmasiNextPage() async {
    nextPage = nextPage + 1;
    MasterFarmasiPencarianModel masterFarmasiPencarianModel =
        MasterFarmasiPencarianModel(namaBarang: namaBarang!);
    try {
      final res = await _repo.getPencarianMasterFarmasi(
          nextPage, masterFarmasiPencarianModel);
      if (_streamPencarianMasterFarmasi!.isClosed) return;
      masterFarmasi!.currentPage = nextPage;
      masterFarmasi!.barangFarmasi!.addAll(res.barangFarmasi!);
      pencarianMasterFarmasiSink.add(ApiResponse.completed(masterFarmasi));
    } catch (e) {
      if (_streamPencarianMasterFarmasi!.isClosed) return;
      pencarianMasterFarmasiSink.add(ApiResponse.completed(masterFarmasi));
    }
  }

  dispose() {
    _streamPencarianMasterFarmasi?.close();
    _namaBarang.close();
  }
}
