import 'dart:async';

import 'package:admin_dokter_panggil/src/models/dokumen_lab_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dokumen_lab_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class DokumenLabBloc {
  final _repo = DokumenLabRepo();
  StreamController<ApiResponse<DokumenLabModel>>? _streamDokumenLab;
  final BehaviorSubject<int> _idPengantar = BehaviorSubject();
  StreamSink<int> get idPengantarSink => _idPengantar.sink;
  StreamSink<ApiResponse<DokumenLabModel>> get dokumenLabSink =>
      _streamDokumenLab!.sink;
  Stream<ApiResponse<DokumenLabModel>> get dokumenLabStream =>
      _streamDokumenLab!.stream;

  Future<void> getDokumenLab() async {
    _streamDokumenLab = StreamController();
    final idPengantar = _idPengantar.value;
    dokumenLabSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getDokumen(idPengantar);
      if (_streamDokumenLab!.isClosed) return;
      dokumenLabSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamDokumenLab!.isClosed) return;
      dokumenLabSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamDokumenLab?.close();
    _idPengantar.close();
  }
}
