import 'dart:async';

import 'package:admin_dokter_panggil/src/models/tindakan_rad_proses_model.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/repositories/tindakan_rad_proses_repo.dart';
import 'package:rxdart/rxdart.dart';

class TindakanRadProsesBloc {
  final _repo = TindakanRadProsesRepo();
  StreamController<ApiResponse<TindakanRadProsesModel>>?
      _streamTindakanRadProses;
  final BehaviorSubject<int> _idPengantar = BehaviorSubject();
  final BehaviorSubject<int> _status = BehaviorSubject();
  final BehaviorSubject<int> _isBersedia = BehaviorSubject();
  StreamSink<int> get idPengantarSink => _idPengantar.sink;
  StreamSink<int> get statusSink => _status.sink;
  StreamSink<int> get isBersediaSink => _isBersedia.sink;
  StreamSink<ApiResponse<TindakanRadProsesModel>> get tindakanRadProsesSink =>
      _streamTindakanRadProses!.sink;
  Stream<ApiResponse<TindakanRadProsesModel>> get tindakanRadProsesStream =>
      _streamTindakanRadProses!.stream;

  Future<void> prosesTindakanRad() async {
    _streamTindakanRadProses = StreamController();
    final idPengantar = _idPengantar.value;
    final status = _status.value;
    final isBersedia = _isBersedia.value;
    tindakanRadProsesSink.add(ApiResponse.loading('Memuat...'));
    TindakanRadProsesRequestModel tindakanRadProsesRequestModel =
        TindakanRadProsesRequestModel(status: status, isBersedia: isBersedia);
    try {
      final res = await _repo.prosesTindakanRad(
          tindakanRadProsesRequestModel, idPengantar);
      if (_streamTindakanRadProses!.isClosed) return;
      tindakanRadProsesSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTindakanRadProses!.isClosed) return;
      tindakanRadProsesSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamTindakanRadProses?.close();
    _idPengantar.close();
    _status.close();
    _isBersedia.close();
  }
}
