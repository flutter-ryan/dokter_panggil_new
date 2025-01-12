import 'dart:async';

import 'package:dokter_panggil/src/models/resep_oral_proses_model.dart';
import 'package:dokter_panggil/src/repositories/resep_oral_proses_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class ResepOralProsesBloc {
  final _repo = ResepOralProsesRepo();
  StreamController<ApiResponse<ResepOralProsesModel>>? _streamResepOralProses;
  final BehaviorSubject<int> _idResepOral = BehaviorSubject();
  final BehaviorSubject<int> _isBersedia = BehaviorSubject();
  final BehaviorSubject<int> _status = BehaviorSubject();
  StreamSink<int> get idResepOralSink => _idResepOral.sink;
  StreamSink<int> get isBersedia => _isBersedia.sink;
  StreamSink<int> get statusSink => _status.sink;
  StreamSink<ApiResponse<ResepOralProsesModel>> get resepOralProsesSink =>
      _streamResepOralProses!.sink;
  Stream<ApiResponse<ResepOralProsesModel>> get resepOralProsesStream =>
      _streamResepOralProses!.stream;
  Future<void> prosesResepOral() async {
    _streamResepOralProses = StreamController();
    final idResepOral = _idResepOral.value;
    final status = _status.value;
    final isBersedia = _isBersedia.value;
    resepOralProsesSink.add(ApiResponse.loading('Memuat...'));
    ResepOralProsesRequestModel resepOralProsesRequestModel =
        ResepOralProsesRequestModel(status: status, isBersedia: isBersedia);
    try {
      final res =
          await _repo.prosesResepOral(resepOralProsesRequestModel, idResepOral);
      if (_streamResepOralProses!.isClosed) return;
      resepOralProsesSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamResepOralProses!.isClosed) return;
      resepOralProsesSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamResepOralProses?.close();
    _idResepOral.close();
    _status.close();
  }
}
