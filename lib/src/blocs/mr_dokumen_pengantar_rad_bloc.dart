import 'dart:async';

import 'package:dokter_panggil/src/models/mr_dokumen_pengantar_rad_model.dart';
import 'package:dokter_panggil/src/repositories/mr_dokumen_pengantar_rad_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MrDokumenPengantarRadBloc {
  final _repo = MrDokumenPengantarRadRepo();
  StreamController<ApiResponse<MrDokumenPengantarRadModel>>?
      _streamDokumenPengantarRad;

  final BehaviorSubject<int> _idPengantar = BehaviorSubject();
  StreamSink<int> get idPengantarSink => _idPengantar.sink;
  StreamSink<ApiResponse<MrDokumenPengantarRadModel>>
      get dokumenPengantarRadSink => _streamDokumenPengantarRad!.sink;
  Stream<ApiResponse<MrDokumenPengantarRadModel>>
      get dokumenPengantarRadStream => _streamDokumenPengantarRad!.stream;

  Future<void> getDokumenPengantarRad() async {
    _streamDokumenPengantarRad = StreamController();
    final idPengantar = _idPengantar.value;
    dokumenPengantarRadSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getDokumenPengantarRad(idPengantar);
      if (_streamDokumenPengantarRad!.isClosed) return;
      dokumenPengantarRadSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamDokumenPengantarRad!.isClosed) return;
      dokumenPengantarRadSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamDokumenPengantarRad?.close();
    _idPengantar.close();
  }
}
