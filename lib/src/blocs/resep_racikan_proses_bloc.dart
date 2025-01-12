import 'dart:async';

import 'package:dokter_panggil/src/models/resep_racikan_proses_model.dart';
import 'package:dokter_panggil/src/repositories/resep_racikan_proses_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class ResepRacikanProsesBloc {
  final _repo = ResepRacikanProsesRepo();
  StreamController<ApiResponse<ResepRacikanProsesModel>>?
      _streamResepRacikanProses;
  final BehaviorSubject<int> _idResepRacikan = BehaviorSubject();
  final BehaviorSubject<int> _isBersedia = BehaviorSubject();
  final BehaviorSubject<int> _status = BehaviorSubject();
  StreamSink<int> get idResepRacikanSink => _idResepRacikan.sink;
  StreamSink<int> get isBersedia => _isBersedia.sink;
  StreamSink<int> get statusSink => _status.sink;
  StreamSink<ApiResponse<ResepRacikanProsesModel>> get resepRacikanProsesSink =>
      _streamResepRacikanProses!.sink;
  Stream<ApiResponse<ResepRacikanProsesModel>> get resepRacikanProsesStream =>
      _streamResepRacikanProses!.stream;
  Future<void> prosesResepRacikan() async {
    _streamResepRacikanProses = StreamController();
    final idResepRacikan = _idResepRacikan.value;
    final status = _status.value;
    final isBersedia = _isBersedia.value;
    resepRacikanProsesSink.add(ApiResponse.loading('Memuat...'));
    ResepRacikanProsesRequestModel resepRacikanProsesRequestModel =
        ResepRacikanProsesRequestModel(status: status, isBersedia: isBersedia);
    try {
      final res = await _repo.prosesResepRacikan(
          resepRacikanProsesRequestModel, idResepRacikan);
      if (_streamResepRacikanProses!.isClosed) return;
      resepRacikanProsesSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamResepRacikanProses!.isClosed) return;
      resepRacikanProsesSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamResepRacikanProses?.close();
    _idResepRacikan.close();
    _status.close();
  }
}
