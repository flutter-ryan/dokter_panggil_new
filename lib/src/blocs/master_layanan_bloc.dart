import 'dart:async';

import 'package:admin_dokter_panggil/src/models/master_layanan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/master_layanan_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';

class MasterLayananBloc {
  final _repo = MasterLayananRepo();
  StreamController<ApiResponse<MasterLayananModel>>? _streamMasterLayanan;
  StreamSink<ApiResponse<MasterLayananModel>> get masterLayananSink =>
      _streamMasterLayanan!.sink;
  Stream<ApiResponse<MasterLayananModel>> get masterLayananStream =>
      _streamMasterLayanan!.stream;

  Future<void> getLayanan() async {
    _streamMasterLayanan = StreamController();
    masterLayananSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getMasterLayanan();
      if (_streamMasterLayanan!.isClosed) return;
      masterLayananSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterLayanan!.isClosed) return;
      masterLayananSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamMasterLayanan?.close();
  }
}
