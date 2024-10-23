import 'dart:async';

import 'package:dokter_panggil/src/models/master_transportasi_tindakan_model.dart';
import 'package:dokter_panggil/src/repositories/master_transportasi_tindakan_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';

class MasterTransportasiTindakanBloc {
  final _repo = MasterTransportasiTindakanRepo();
  StreamController<ApiResponse<MasterTransportasiTindakanModel>>?
      _streamTransportasiTindakan;
  StreamSink<ApiResponse<MasterTransportasiTindakanModel>>
      get transportasiTindakanSink => _streamTransportasiTindakan!.sink;
  Stream<ApiResponse<MasterTransportasiTindakanModel>>
      get transportasiTindakanStream => _streamTransportasiTindakan!.stream;
  Future<void> getTransportasiTindakan() async {
    _streamTransportasiTindakan = StreamController();
    transportasiTindakanSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getTransportasiTindakan();
      if (_streamTransportasiTindakan!.isClosed) return;
      transportasiTindakanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTransportasiTindakan!.isClosed) return;
      transportasiTindakanSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamTransportasiTindakan?.close();
  }
}
