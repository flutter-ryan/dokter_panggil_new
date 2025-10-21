import 'dart:async';

import 'package:admin_dokter_panggil/src/models/transportasi_tindakan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/repositories/transportasi_tindakan_repo.dart';
import 'package:rxdart/subjects.dart';

class TransportasiTindakanBloc {
  final _repo = TransportasiTindakanRepo();
  StreamController<ApiResponse<ResponseTransportasiTindakanModel>>?
      _srteamTransportasiTindakan;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<int> _tindakanKunjungan = BehaviorSubject();
  final BehaviorSubject<int> _jarak = BehaviorSubject();
  final BehaviorSubject<int> _nilai = BehaviorSubject();
  final BehaviorSubject<int> _idTransportTindakan = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<int> get tindakanKunjunganSink => _tindakanKunjungan.sink;
  StreamSink<int> get jarakSink => _jarak.sink;
  StreamSink<int> get nilaiSink => _nilai.sink;
  StreamSink<int> get idTransportTindakan => _idTransportTindakan.sink;
  StreamSink<ApiResponse<ResponseTransportasiTindakanModel>>
      get transportasiTindakanSink => _srteamTransportasiTindakan!.sink;
  Stream<ApiResponse<ResponseTransportasiTindakanModel>>
      get transportasiTindakanStream => _srteamTransportasiTindakan!.stream;

  Future<void> simpanTransportasiTindakan() async {
    _srteamTransportasiTindakan = StreamController();
    final id = _id.value;
    final tindakanKunjungan = _tindakanKunjungan.value;
    final jarak = _jarak.value;
    final nilai = _nilai.value;
    transportasiTindakanSink.add(ApiResponse.loading('Memuat...'));
    TransportasiTindakanModel transportasiTindakanModel =
        TransportasiTindakanModel(
            tindakanKunjungan: tindakanKunjungan, jarak: jarak, nilai: nilai);
    try {
      final res =
          await _repo.saveTransportasiTindakan(transportasiTindakanModel, id);
      if (_srteamTransportasiTindakan!.isClosed) return;
      transportasiTindakanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_srteamTransportasiTindakan!.isClosed) return;
      transportasiTindakanSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> deleteTransportasiTindakan() async {
    _srteamTransportasiTindakan = StreamController();
    final idTransportTindakan = _idTransportTindakan.value;
    transportasiTindakanSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deleteTransportasiTindakan(idTransportTindakan);
      if (_srteamTransportasiTindakan!.isClosed) return;
      transportasiTindakanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_srteamTransportasiTindakan!.isClosed) return;
      transportasiTindakanSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _srteamTransportasiTindakan?.close();
    _id.close();
    _tindakanKunjungan.close();
    _jarak.close();
    _idTransportTindakan.close();
  }
}
