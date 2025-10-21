import 'dart:async';

import 'package:admin_dokter_panggil/src/models/transportasi_kunjungan_tindakan_lab_model.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/repositories/transportasi_kunjungan_tindakan_lab_repo.dart';
import 'package:rxdart/subjects.dart';

class TransportasiKunjunganTindakanLabBloc {
  final _repo = TransportasiKunjunganTindakanLabRepo();
  StreamController<ApiResponse<ResponseTransportasiKunjunganTindakanLabModel>>?
      _streamTransportTindakanLab;

  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<int> _transportasi = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<int> get transportasiSink => _transportasi.sink;
  StreamSink<ApiResponse<ResponseTransportasiKunjunganTindakanLabModel>>
      get transportTindakanLabSink => _streamTransportTindakanLab!.sink;
  Stream<ApiResponse<ResponseTransportasiKunjunganTindakanLabModel>>
      get transportasiTindakanLabStream => _streamTransportTindakanLab!.stream;

  Future<void> saveTransportasiTindakanLab() async {
    _streamTransportTindakanLab = StreamController();
    final id = _id.value;
    final transportasi = _transportasi.value;
    transportTindakanLabSink.add(ApiResponse.loading('Memuat...'));
    TransportasiKunjunganTindakanLabModel
        transportasiKunjunganTindakanLabModel =
        TransportasiKunjunganTindakanLabModel(transportasi: transportasi);
    try {
      final res = await _repo.saveTransportKunjunganTindakanLab(
          transportasiKunjunganTindakanLabModel, id);
      if (_streamTransportTindakanLab!.isClosed) return;
      transportTindakanLabSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTransportTindakanLab!.isClosed) return;
      transportTindakanLabSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamTransportTindakanLab?.close();
    _id.close();
    _transportasi.close();
  }
}
