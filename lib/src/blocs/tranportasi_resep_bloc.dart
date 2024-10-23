import 'dart:async';

import 'package:dokter_panggil/src/models/transportasi_resep_model.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/repositories/transportasi_resep_repo.dart';
import 'package:rxdart/subjects.dart';

class TransportasiResepBloc {
  final _repo = TransportasiResepRepo();
  StreamController<ApiResponse<ResponseTransportasiResepModel>>?
      _streamTransportasiResep;

  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  final BehaviorSubject<int> _biaya = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<int> get biayaSink => _biaya.sink;
  StreamSink<ApiResponse<ResponseTransportasiResepModel>>
      get transportasiResepSink => _streamTransportasiResep!.sink;
  Stream<ApiResponse<ResponseTransportasiResepModel>>
      get transportasiResepStream => _streamTransportasiResep!.stream;

  Future<void> saveTransportasiResep() async {
    _streamTransportasiResep = StreamController();
    final idKunjungan = _idKunjungan.value;
    final biaya = _biaya.value;
    transportasiResepSink.add(ApiResponse.loading('Memuat...'));
    TransportasiResepModel transportasiResepModel =
        TransportasiResepModel(idKunjungan: idKunjungan, biaya: biaya);
    try {
      final res = await _repo.saveTransportResep(transportasiResepModel);
      if (_streamTransportasiResep!.isClosed) return;
      transportasiResepSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTransportasiResep!.isClosed) return;
      transportasiResepSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamTransportasiResep?.close();
    _idKunjungan.close();
    _biaya.close();
  }
}
