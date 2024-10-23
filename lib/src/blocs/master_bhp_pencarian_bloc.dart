import 'dart:async';

import 'package:dokter_panggil/src/models/master_bhp_paginate_model.dart';
import 'package:dokter_panggil/src/models/master_bhp_pencarian_model.dart';
import 'package:dokter_panggil/src/repositories/master_bhp_pencarian_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MasterBhpPencarianBloc {
  MasterBhpPaginateModel? masterBhp;
  int initialPage = 1;
  int nextPage = 1;
  String? namaBarang;
  final _repo = MasterBhpPencarianRepo();
  StreamController<ApiResponse<MasterBhpPaginateModel>>?
      _streamPencarianMasterBhp;
  final BehaviorSubject<String> _namaBarang = BehaviorSubject();
  StreamSink<String> get namaBarangSink => _namaBarang.sink;
  StreamSink<ApiResponse<MasterBhpPaginateModel>> get pencarianMasterBhpSink =>
      _streamPencarianMasterBhp!.sink;
  Stream<ApiResponse<MasterBhpPaginateModel>> get pencarianMasterBhpStream =>
      _streamPencarianMasterBhp!.stream;

  Future<void> getPencarianMasterBhp() async {
    _streamPencarianMasterBhp = StreamController();
    namaBarang = _namaBarang.value;
    pencarianMasterBhpSink.add(ApiResponse.loading('Memuat...'));
    MasterBhpPencarianModel masterBhpPencarianModel =
        MasterBhpPencarianModel(namaBarang: namaBarang!);
    try {
      final res = await _repo.getPencarianMasterBhp(
          initialPage, masterBhpPencarianModel);
      if (_streamPencarianMasterBhp!.isClosed) return;
      masterBhp = res;
      nextPage = 1;
      pencarianMasterBhpSink.add(ApiResponse.completed(masterBhp));
    } catch (e) {
      if (_streamPencarianMasterBhp!.isClosed) return;
      pencarianMasterBhpSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getPencarianMasterBhpNextPage() async {
    nextPage = nextPage + 1;
    MasterBhpPencarianModel masterBhpPencarianModel =
        MasterBhpPencarianModel(namaBarang: namaBarang!);
    try {
      final res =
          await _repo.getPencarianMasterBhp(nextPage, masterBhpPencarianModel);
      if (_streamPencarianMasterBhp!.isClosed) return;
      masterBhp!.currentPage = nextPage;
      masterBhp!.bhp!.addAll(res.bhp!);
      pencarianMasterBhpSink.add(ApiResponse.completed(masterBhp));
    } catch (e) {
      if (_streamPencarianMasterBhp!.isClosed) return;
      pencarianMasterBhpSink.add(ApiResponse.completed(masterBhp));
    }
  }

  dispose() {
    _streamPencarianMasterBhp?.close();
    _namaBarang.close();
  }
}
