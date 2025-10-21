import 'dart:async';

import 'package:admin_dokter_panggil/src/models/master_bhp_paginate_model.dart';
import 'package:admin_dokter_panggil/src/repositories/master_bhp_paginate_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';

class MasterBhpPaginateBloc {
  MasterBhpPaginateModel? masterBhp;
  int initialPage = 1;
  int nextPage = 1;
  final _repo = MasterBhpPaginateRepo();
  StreamController<ApiResponse<MasterBhpPaginateModel>>? _streamMasterBhp;
  StreamSink<ApiResponse<MasterBhpPaginateModel>> get masterBhpSink =>
      _streamMasterBhp!.sink;
  Stream<ApiResponse<MasterBhpPaginateModel>> get masterBhpStream =>
      _streamMasterBhp!.stream;

  Future<void> getMasterBhp() async {
    _streamMasterBhp = StreamController();
    masterBhpSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getMasterBhp(initialPage);
      if (_streamMasterBhp!.isClosed) return;
      masterBhp = res;
      nextPage = 1;
      masterBhpSink.add(ApiResponse.completed(masterBhp));
    } catch (e) {
      if (_streamMasterBhp!.isClosed) return;
      masterBhpSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getBhpNextPage() async {
    nextPage = nextPage + 1;
    try {
      final res = await _repo.getMasterBhp(nextPage);
      if (_streamMasterBhp!.isClosed) return;
      masterBhp!.currentPage = nextPage;
      masterBhp!.bhp!.addAll(res.bhp!);
      masterBhpSink.add(ApiResponse.completed(masterBhp));
    } catch (e) {
      if (_streamMasterBhp!.isClosed) return;
      masterBhpSink.add(ApiResponse.completed(masterBhp));
    }
  }

  void dispose() {
    _streamMasterBhp?.close();
  }
}
