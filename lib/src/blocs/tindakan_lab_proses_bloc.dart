import 'dart:async';

import 'package:dokter_panggil/src/models/tindakan_lab_proses_model.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/repositories/tindakan_lab_proses_repo.dart';
import 'package:rxdart/rxdart.dart';

class TindakanLabProsesBloc {
  final _repo = TindakanLabProsesRepo();
  StreamController<ApiResponse<TindakanLabProsesModel>>?
      _streamTindakanLabProses;
  final BehaviorSubject<int> _idPengantar = BehaviorSubject();
  final BehaviorSubject<int> _status = BehaviorSubject();
  final BehaviorSubject<int> _isBersedia = BehaviorSubject();
  StreamSink<int> get idPengantarSink => _idPengantar.sink;
  StreamSink<int> get statusSink => _status.sink;
  StreamSink<int> get isBersediaSink => _isBersedia.sink;
  StreamSink<ApiResponse<TindakanLabProsesModel>> get tindakanLabProsesSink =>
      _streamTindakanLabProses!.sink;
  Stream<ApiResponse<TindakanLabProsesModel>> get tindakanLabProsesStream =>
      _streamTindakanLabProses!.stream;

  Future<void> prosesTindakanLab() async {
    _streamTindakanLabProses = StreamController();
    final idPengantar = _idPengantar.value;
    final status = _status.value;
    final isBersedia = _isBersedia.value;
    tindakanLabProsesSink.add(ApiResponse.loading('Memuat...'));
    TindakanLabProsesRequestModel tindakanLabProsesRequestModel =
        TindakanLabProsesRequestModel(status: status, isBersedia: isBersedia);
    try {
      final res = await _repo.prosesTindakanLab(
          tindakanLabProsesRequestModel, idPengantar);
      if (_streamTindakanLabProses!.isClosed) return;
      tindakanLabProsesSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTindakanLabProses!.isClosed) return;
      tindakanLabProsesSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamTindakanLabProses?.close();
    _idPengantar.close();
    _status.close();
    _isBersedia.close();
  }
}
