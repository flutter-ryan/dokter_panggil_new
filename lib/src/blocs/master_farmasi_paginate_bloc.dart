import 'dart:async';

import 'package:dokter_panggil/src/models/master_farmasi_paginate_model.dart';
import 'package:dokter_panggil/src/repositories/master_farmasi_paginate_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MasterFarmasiPaginateBloc {
  final _repo = MasterFarmasiPaginateRepo();
  MasterFarmasiPaginateModel? masterFarmasi;
  int initialPage = 1;
  int nextPage = 1;
  StreamController<ApiResponse<MasterFarmasiPaginateModel>>?
      _streamMasterFarmasiPaginate;
  final BehaviorSubject<int> _idMitra = BehaviorSubject.seeded(0);
  StreamSink<int> get idMitraSink => _idMitra.sink;
  StreamSink<ApiResponse<MasterFarmasiPaginateModel>>
      get masterFarmasiPaginateSink => _streamMasterFarmasiPaginate!.sink;
  Stream<ApiResponse<MasterFarmasiPaginateModel>>
      get masterFarmasiPaginateStream => _streamMasterFarmasiPaginate!.stream;

  Future<void> getMasterFarmasiPaginate() async {
    _streamMasterFarmasiPaginate = StreamController();
    final idMitra = _idMitra.value;
    masterFarmasiPaginateSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getMasterFarmasiMitra(initialPage, idMitra);
      if (_streamMasterFarmasiPaginate!.isClosed) return;
      masterFarmasi = res;
      nextPage = res.currentPage!;
      masterFarmasiPaginateSink.add(ApiResponse.completed(masterFarmasi));
    } catch (e) {
      if (_streamMasterFarmasiPaginate!.isClosed) return;
      masterFarmasiPaginateSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getMasterFarmasiNextPage() async {
    nextPage = nextPage + 1;
    final idMitra = _idMitra.value;
    try {
      final res = await _repo.getMasterFarmasiMitra(nextPage, idMitra);
      if (_streamMasterFarmasiPaginate!.isClosed) return;
      masterFarmasi!.currentPage = nextPage;
      masterFarmasi!.barangFarmasi!.addAll(res.barangFarmasi!);
      masterFarmasiPaginateSink.add(ApiResponse.completed(masterFarmasi));
    } catch (e) {
      if (_streamMasterFarmasiPaginate!.isClosed) return;
      masterFarmasiPaginateSink.add(ApiResponse.completed(masterFarmasi));
    }
  }

  Future<void> getMasterFarmasiMitraPaginate() async {
    _streamMasterFarmasiPaginate = StreamController();
    final idMitra = _idMitra.value;
    masterFarmasiPaginateSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getMasterFarmasiMitra(initialPage, idMitra);
      if (_streamMasterFarmasiPaginate!.isClosed) return;
      masterFarmasi = res;
      nextPage = res.currentPage!;
      masterFarmasiPaginateSink.add(ApiResponse.completed(masterFarmasi));
    } catch (e) {
      if (_streamMasterFarmasiPaginate!.isClosed) return;
      masterFarmasiPaginateSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamMasterFarmasiPaginate?.close();
  }
}
