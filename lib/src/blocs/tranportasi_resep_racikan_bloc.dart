import 'dart:async';

import 'package:dokter_panggil/src/models/transportasi_resep_racikan_model.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/repositories/transportasi_resep_racikan_repo.dart';
import 'package:rxdart/subjects.dart';

class TransportasiResepRacikanBloc {
  final _repo = TransportasiResepRacikanRepo();
  StreamController<ApiResponse<ResponseTransportasiResepRacikanModel>>?
      _streamTransportasiResepRacikan;
  final BehaviorSubject<String> _idResep = BehaviorSubject.seeded('');
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  final BehaviorSubject<int> _biaya = BehaviorSubject();
  StreamSink<String> get idResepSink => _idResep.sink;
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<int> get biayaSink => _biaya.sink;
  StreamSink<ApiResponse<ResponseTransportasiResepRacikanModel>>
      get transportasiResepRacikanSink => _streamTransportasiResepRacikan!.sink;
  Stream<ApiResponse<ResponseTransportasiResepRacikanModel>>
      get transportasiResepRacikanStream =>
          _streamTransportasiResepRacikan!.stream;

  Future<void> saveTransportasiResepRacikan() async {
    _streamTransportasiResepRacikan = StreamController();
    final idKunjungan = _idKunjungan.value;
    final biaya = _biaya.value;
    final idResep = _idResep.value;
    transportasiResepRacikanSink.add(ApiResponse.loading('Memuat...'));
    TransportasiResepRacikanModel transportasiResepRacikanModel =
        TransportasiResepRacikanModel(
            idKunjungan: idKunjungan, biaya: biaya, idResep: idResep);
    try {
      final res = await _repo.saveTransportResep(transportasiResepRacikanModel);
      if (_streamTransportasiResepRacikan!.isClosed) return;
      transportasiResepRacikanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTransportasiResepRacikan!.isClosed) return;
      transportasiResepRacikanSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamTransportasiResepRacikan?.close();
    _idKunjungan.close();
    _biaya.close();
  }
}
