import 'dart:async';

import 'package:dokter_panggil/src/models/master_tindakan_model.dart';
import 'package:dokter_panggil/src/repositories/master_tindakan_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';

class MasterTindakanBloc {
  final _repo = MasterTindakanRepo();
  StreamController<ApiResponse<MasterTindakanModel>>? _streamMasterTindakan;

  StreamSink<ApiResponse<MasterTindakanModel>> get masterTindakanSink =>
      _streamMasterTindakan!.sink;
  Stream<ApiResponse<MasterTindakanModel>> get masterTindakanStream =>
      _streamMasterTindakan!.stream;

  Future<void> fetchMasterTindakan() async {
    _streamMasterTindakan = StreamController();
    masterTindakanSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.fetchMasterTindakan();
      if (_streamMasterTindakan!.isClosed) return;
      masterTindakanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterTindakan!.isClosed) return;
      masterTindakanSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamMasterTindakan?.close();
  }
}
